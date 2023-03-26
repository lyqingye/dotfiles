return {
  { "navarasu/onedark.nvim" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },

  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "help",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "vim",
        "yaml",
        "go",
        "rust",
      },
    },
  },

  {

    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- lua
        "stylua",
        "shfmt",

        -- bash
        "bash-language-server",

        -- golang
        "gopls",
        "delve",
        "glint",
        "goimports",
        "golines",
        "gofumpt",

        -- rust
        "rust-analyzer",
        "rustfmt",

        -- cpp
        "cmake-language-server",
        "clangd",
        "codelldb",
        "cpplint",
        "clang-format",

        -- docker
        "dockerfile-language-server",
        "docker-compose-language-service",
      },
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function()
      local nls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.shfmt,
        },
      }
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    opts = {
      close_if_last_window = true,
      window = {
        mappings = {
          ["<space>"] = "none",
          ["o"] = "open",
        },
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>dr",
        function()
          require("dap").run()
        end,
        desc = "Debug Run",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Debug Continue",
      },
      {
        "<leader>drl",
        function()
          require("dap").run_last()
        end,
        desc = "Debug Run Last",
      },
      {
        "<leader>drs",
        function()
          require("dap").restart()
        end,
        desc = "Debug Restart",
      },
      {
        "<leader>dq",
        function()
          require("dap").terminate()
        end,
        desc = "Debug Quite(terminate)",
      },
      {
        "<leader>dbp",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Debug Toggle breakpoint",
      },
      {
        "<leader>dlbp",
        function()
          require("dap").list_breakpoints()
        end,
        desc = "Debug List breakpoints",
      },

      {
        "<F7>",
        function()
          local dap = require("dap")
          if dap.status() ~= nil then
            dap.step_into()
          end
        end,
        desc = "Debug step into",
      },
      {
        "<F8>",
        function()
          local dap = require("dap")
          if dap.status() ~= nil then
            dap.step_out()
          end
        end,
        desc = "Debug step out",
      },
    },
  },

  {
    "rcarriga/nvim-dap-ui",
    opts = function(_, opts)
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        require("neo-tree.command").execute({ toggle = true, dir = require("lazyvim.util").get_root() })
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        require("neo-tree.command").execute({ toggle = true, dir = require("lazyvim.util").get_root() })
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        require("neo-tree.command").execute({ toggle = true, dir = require("lazyvim.util").get_root() })
        dapui.close()
      end
    end,
    dependencies = {
      "mfussenegger/nvim-dap",
    },
  },

  {
    "leoluz/nvim-dap-go",
    keys = {
      {
        "<leader>dt",
        function()
          require("dap-go").debug_test()
        end,
        desc = "Debug Test",
      },
      {
        "<leader>dlt",
        function()
          require("dap-go").debug_last_test()
        end,
        desc = "Debug Last Test",
      },
    },
    opts = {
      dap_configurations = {
        {
          type = "go",
          name = "Attach remote",
          mode = "remote",
          request = "attach",
        },
      },
      delve = {
        initialize_timeout_sec = 20,
        port = "${port}",
      },
    },
    dependencies = {
      "mfussenegger/nvim-dap",
    },
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    opts = {
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
    },
  },
}
