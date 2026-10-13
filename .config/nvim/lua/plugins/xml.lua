return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    local server = vim.fn.stdpath("data") .. "/lemminx-maven/0.12.0"
    local cmd
    if
      vim.fn.filereadable(server .. "/server.jar") == 1
      and vim.fn.filereadable(server .. "/lib/lemminx-maven-0.12.0.jar") == 1
    then
      -- Maven property navigation requires the JVM server and Maven extension.
      cmd = { "java", "-cp", server .. "/server.jar:" .. server .. "/lib/*", "org.eclipse.lemminx.XMLServerLauncher" }
    end
    opts.servers = opts.servers or {}
    opts.servers.lemminx = vim.tbl_deep_extend("force", opts.servers.lemminx or {}, {
      cmd = cmd,
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
  end,
}
