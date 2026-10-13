return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      lemminx = {
        settings = {
          xml = {
            downloadExternalResources = { enabled = true },
            -- Complete Maven tags even before schemaLocation is added to a new POM.
            fileAssociations = {
              { pattern = "pom.xml", systemId = "https://maven.apache.org/xsd/maven-4.0.0.xsd" },
            },
          },
        },
      },
    },
  },
}
