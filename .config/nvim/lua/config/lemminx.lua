local M = {}

function M.setup(opts, destination)
  local filetypes = { "xml", "xsd", "xsl", "xslt", "svg" }
  local running, attempted = false, false
  local group = vim.api.nvim_create_augroup("lemminx_maven_install", { clear = true })

  local function installed()
    return vim.fn.filereadable(destination .. "/server.jar") == 1
      and vim.fn.filereadable(destination .. "/lib/lemminx-maven-0.12.0.jar") == 1
      and vim.fn.filereadable(destination .. "/.ready-0.30.1") == 1
  end

  local function enable()
    vim.api.nvim_clear_autocmds({ group = group })
    vim.lsp.enable("lemminx")
  end

  local function fail(message)
    vim.notify(message .. "\nRun :LemminxMavenInstall to retry.", vim.log.levels.ERROR, { title = "LemMinX Maven" })
  end

  local function install()
    if running then
      return
    end
    if installed() then
      enable()
      return
    end
    attempted = true
    for _, tool in ipairs({ "java", "bash", "curl", "unzip" }) do
      if vim.fn.executable(tool) ~= 1 then
        fail("Missing executable: " .. tool)
        return
      end
    end
    running = true
    vim.notify("Installing XML server and Maven extension…", vim.log.levels.INFO, { title = "LemMinX Maven" })
    local ok, err = pcall(vim.system, {
      "bash",
      vim.fn.stdpath("config") .. "/scripts/install-lemminx-maven.sh",
      destination,
    }, { text = true }, function(result)
      vim.schedule(function()
        running = false
        if result.code ~= 0 or not installed() then
          fail("Installation failed:\n" .. vim.trim(result.stderr or result.stdout or ""))
          return
        end
        enable()
        vim.notify("Installed; XML and Maven support enabled.", vim.log.levels.INFO, { title = "LemMinX Maven" })
      end)
    end)
    if not ok then
      running = false
      fail("Could not start installer: " .. tostring(err))
    end
  end

  vim.lsp.config("lemminx", opts)
  vim.api.nvim_create_user_command("LemminxMavenInstall", install, {
    desc = "Install the XML server and Maven extension, or retry a failed installation",
    force = true,
  })
  if installed() then
    enable()
    return
  end
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = filetypes,
    callback = function()
      if not attempted then
        install()
      end
    end,
  })
  -- LazyVim may load the LSP configuration during the first buffer's FileType event.
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.tbl_contains(filetypes, vim.bo[buf].filetype) then
      install()
      break
    end
  end
end

return M
