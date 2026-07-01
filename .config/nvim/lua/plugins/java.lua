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

return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      opts.cmd = opts.cmd or { vim.fn.exepath("jdtls") }

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
        },
      })
    end,
  },
}
