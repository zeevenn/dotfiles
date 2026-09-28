return {
  {
    "rcarriga/nvim-dap-ui",
    keys = {
      { "<leader>dx", "<cmd>DapClearConsole<cr>", desc = "Clear DAP Console" },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup(opts)

      local function clear_console()
        local console = dapui.elements.console
        local buf = console and console.buffer()
        if not (buf and vim.api.nvim_buf_is_valid(buf)) then
          return
        end

        local was_modifiable = vim.bo[buf].modifiable
        vim.bo[buf].modifiable = true
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "" })
        vim.bo[buf].modified = false
        vim.bo[buf].modifiable = was_modifiable
      end

      local function console_has_output()
        local console = dapui.elements.console
        local buf = console and console.buffer()
        if not (buf and vim.api.nvim_buf_is_valid(buf)) then
          return false
        end

        for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
          if line:find("%S") then
            return true
          end
        end
        return false
      end

      local function close_if_console_is_empty()
        -- Let the terminal flush its final output before deciding.
        vim.defer_fn(function()
          if not console_has_output() then
            dapui.close({})
          end
        end, 100)
      end

      dap.listeners.after.event_initialized["dapui_config"] = function()
        clear_console()
        dapui.open({})
      end

      dap.listeners.before.event_terminated["dapui_config"] = close_if_console_is_empty
      dap.listeners.before.event_exited["dapui_config"] = close_if_console_is_empty

      vim.api.nvim_create_user_command("DapClearConsole", function()
        if dap.session() then
          vim.notify("Stop the debug session before clearing its console", vim.log.levels.WARN)
          return
        end

        clear_console()
      end, { desc = "Clear DAP Console output" })
    end,
  },
}
