-- Run: nvim --headless -u NONE -l .config/nvim/tests/lemminx.lua
local config = vim.fs.dirname(vim.fs.dirname(debug.getinfo(1, "S").source:sub(2)))
vim.opt.rtp:prepend(config)

local directory = vim.fn.tempname()
vim.fn.mkdir(directory .. "/lib", "p")
for _, name in ipairs({ "server.jar", "lib/lemminx-maven-0.12.0.jar", ".ready-0.30.1" }) do
  vim.fn.writefile({}, directory .. "/" .. name)
end

local original_config, original_enable = vim.lsp.config, vim.lsp.enable
local ok, err = xpcall(function()
  local server_opts
  vim.lsp.config = function(name, opts)
    assert(name == "lemminx")
    server_opts = opts
  end
  vim.lsp.enable = function() end
  require("config.lemminx").setup({}, directory)
  vim.lsp.config, vim.lsp.enable = original_config, original_enable

  local method = "textDocument/publishDiagnostics"
  local handler = (server_opts.handlers or {})[method] or vim.lsp.handlers[method]
  local context = { client_id = 9876, method = method }
  local namespace = vim.lsp.diagnostic.get_namespace(context.client_id)
  local java_namespace = vim.api.nvim_create_namespace("test.jdtls")

  local function buffer(name, filetype, text)
    local buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_set_name(buf, directory .. "/" .. name)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { text })
    vim.bo[buf].filetype = filetype
    return buf
  end

  local function publish(uri, diagnostics)
    handler(nil, { uri = uri, diagnostics = diagnostics }, context)
  end

  local diagnostic = {
    source = "xml",
    code = "ContentIllegalInProlog",
    message = "Content is not allowed in prolog.",
    severity = 1,
    range = { start = { line = 0, character = 0 }, ["end"] = { line = 0, character = 1 } },
  }
  local java = buffer("ResourceUserService.java", "java", "package example;")
  vim.diagnostic.set(java_namespace, java, { { lnum = 0, col = 0, message = "Java error" } })
  -- Seed the stale XML diagnostic seen in the running editor, then replay its packet.
  vim.lsp.handlers[method](nil, { uri = vim.uri_from_bufnr(java), diagnostics = { diagnostic } }, context)
  publish(vim.uri_from_bufnr(java), { diagnostic })
  assert(#vim.diagnostic.get(java, { namespace = namespace }) == 0, "XML diagnostic leaked into Java")
  assert(#vim.diagnostic.get(java, { namespace = java_namespace }) == 1, "Java diagnostic was removed")

  for _, filetype in ipairs({ "xml", "xsd", "xsl", "xslt", "svg" }) do
    local buf = buffer("example." .. filetype, filetype, "<broken>")
    publish(vim.uri_from_bufnr(buf), { diagnostic })
    assert(#vim.diagnostic.get(buf, { namespace = namespace }) == 1, filetype .. " diagnostic was lost")
    publish(vim.uri_from_bufnr(buf), {})
    assert(#vim.diagnostic.get(buf, { namespace = namespace }) == 0, filetype .. " diagnostic was not cleared")
  end

  -- Publishing must also reject Java files that have never been opened.
  local unopened = directory .. "/Unopened.java"
  assert(vim.fn.bufnr(unopened) == -1)
  publish(vim.uri_from_fname(unopened), { diagnostic })
  assert(vim.fn.bufnr(unopened) == -1, "Rejected diagnostic created a Java buffer")

  -- The actual buffer filetype takes precedence over the filename extension.
  local custom_xml = buffer("custom.java", "xml", "<broken>")
  publish(vim.uri_from_bufnr(custom_xml), { diagnostic })
  assert(#vim.diagnostic.get(custom_xml, { namespace = namespace }) == 1, "Explicit XML filetype was ignored")

  print("PASS: XML diagnostics stay in XML files; Java diagnostics remain intact")
end, debug.traceback)

vim.lsp.config, vim.lsp.enable = original_config, original_enable
vim.fn.delete(directory, "rf")
if not ok then
  error(err)
end
