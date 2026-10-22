local function java_home(version)
  local output = vim.fn.system({ "/usr/libexec/java_home", "-v", version })
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return vim.trim(output)
end

local function java_runtime(version, name, default)
  local path = java_home(version)
  if not path then
    return nil
  end
  return { name = name, path = path, default = default or nil }
end

local function jdtls_java_home()
  for _, version in ipairs({ "21", "22", "23", "24", "25" }) do
    local path = java_home(version)
    if path then
      return path
    end
  end
end

local function has_java_executable(cmd)
  for _, arg in ipairs(cmd) do
    if arg:match("^%-%-java%-executable") then
      return true
    end
  end
  return false
end

local function run_java_main()
  local bufnr = vim.api.nvim_get_current_buf()
  local client = vim.lsp.get_clients({ bufnr = bufnr, name = "jdtls" })[1]
  if not client or not require("dap").adapters.java then
    vim.notify("Wait for the Java language server and debugger to finish starting", vim.log.levels.WARN)
    return
  end
  vim.cmd.update()

  -- Ask JDTLS about this file, including nested classes and the owning module.
  client:exec_cmd({
    command = "vscode.java.resolveMainMethod",
    arguments = { vim.uri_from_bufnr(bufnr) },
  }, { bufnr = bufnr }, function(err, mains)
    if err then
      vim.notify(err.message, vim.log.levels.ERROR)
      return
    end
    if not mains or #mains == 0 then
      vim.notify("No Java main method found in the current file", vim.log.levels.WARN)
      return
    end

    local function launch(main)
      if not main or not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end
      vim.api.nvim_buf_call(bufnr, function()
        require("dapui").open()
        require("dap").run({
          type = "java",
          request = "launch",
          name = "Run " .. main.mainClass,
          mainClass = main.mainClass,
          projectName = main.projectName,
          cwd = client.config.root_dir,
          noDebug = true,
          console = "integratedTerminal",
        })
      end)
    end

    if #mains == 1 then
      launch(mains[1])
    else
      vim.ui.select(mains, {
        prompt = "Run Java main class",
        format_item = function(main)
          return main.mainClass
        end,
      }, launch)
    end
  end)
end

return {
  {
    "mfussenegger/nvim-jdtls",
    keys = {
      { "<leader>dR", run_java_main, desc = "Run Java Main Class", ft = "java" },
    },
    opts = function(_, opts)
      opts.cmd = opts.cmd or { vim.fn.exepath("jdtls") }

      -- Bound Maven Central artifact lookup when jumping into dependencies without sources.
      -- jdtls defaults to 10 seconds before falling back to the local Maven repository.
      table.insert(opts.cmd, "--jvm-arg=-Djava.lsp.mavensearch.timeout=2")

      -- Discover main classes on dap.continue(), instead of scanning on every LspAttach.
      opts.dap_main = false

      -- Complete the shutdown/exit handshake before quitting Neovim, so a quick reopen
      -- does not race the old server while it is saving and releasing the workspace.
      local jdtls_config = opts.jdtls
      opts.jdtls = function(config)
        if type(jdtls_config) == "function" then
          config = jdtls_config(config) or config
        else
          config = vim.tbl_deep_extend("force", config, jdtls_config or {})
        end
        config.exit_timeout = 5000

        -- Mason exposes both versioned JARs and aliases. Load each bundle once;
        -- the test runner and coverage agent are launched separately, not by OSGi.
        local bundles, seen = {}, {}
        local jdtls_plugins = vim.fn.expand("$MASON/packages/jdtls/plugins/")
        for _, jar in ipairs(config.init_options.bundles or {}) do
          local name = vim.fs.basename(jar)
          local path = vim.uv.fs_realpath(jar) or jar
          if
            name ~= "com.microsoft.java.test.runner-jar-with-dependencies.jar"
            and name ~= "jacocoagent.jar"
            -- java-test can also ship the exact ASM bundles already in jdtls.
            and vim.fn.filereadable(jdtls_plugins .. name) == 0
            and not seen[path]
          then
            seen[path] = true
            table.insert(bundles, path)
          end
        end
        config.init_options.bundles = bundles
        return config
      end

      -- Newer jdtls releases require Java 21+ to run, while projects can still target Java 17.
      local jdtls_home = jdtls_java_home()
      if jdtls_home and not has_java_executable(opts.cmd) then
        table.insert(opts.cmd, 2, "--java-executable=" .. jdtls_home .. "/bin/java")
      end

      local runtimes = {}
      for _, runtime in ipairs({
        java_runtime("1.8", "JavaSE-1.8"),
        java_runtime("17", "JavaSE-17", true),
        java_runtime("21", "JavaSE-21"),
        java_runtime("25", "JavaSE-25"),
      }) do
        if runtime then
          table.insert(runtimes, runtime)
        end
      end

      opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
        java = {
          configuration = {
            runtimes = runtimes,
          },
          format = {
            comments = {
              enabled = false,
            },
          },
        },
      })
    end,
  },
}
