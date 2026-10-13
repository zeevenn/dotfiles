return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    local server = vim.fn.stdpath("data") .. "/lemminx-maven/0.12.0"
    opts.servers = opts.servers or {}
    opts.servers.lemminx = vim.tbl_deep_extend("force", opts.servers.lemminx or {}, {
      -- Mason's native binary cannot load the Maven extension's JVM jars.
      mason = false,
      cmd = { "java", "-cp", server .. "/server.jar:" .. server .. "/lib/*", "org.eclipse.lemminx.XMLServerLauncher" },
      root_markers = { ".git", "pom.xml" },
      settings = {
        xml = {
          downloadExternalResources = { enabled = true },
          -- Complete Maven tags even before schemaLocation is added to a new POM.
          fileAssociations = {
            { pattern = "pom.xml", systemId = "https://maven.apache.org/xsd/maven-4.0.0.xsd" },
          },
        },
      },
    })
    opts.setup = opts.setup or {}
    opts.setup.lemminx = function(_, server_opts)
      require("config.lemminx").setup(server_opts, server)
      return true
    end
  end,
}
