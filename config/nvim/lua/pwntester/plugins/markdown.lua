return {
  {
    "jakewvincent/mkdnflow.nvim",
    opts = {
      modules = {
        bib = true,
        buffers = true,
        conceal = true,
        cursor = true,
        folds = true,
        foldtext = true,
        links = true,
        lists = true,
        maps = true,
        paths = true,
        tables = true,
        yaml = false,
        cmp = false,
      },
      filetypes = { md = true, rmd = true, markdown = true },
      create_dirs = true,
      perspective = {
        priority = "first",
        fallback = "current",
        root_tell = false,
        nvim_wd_heel = false,
        update = false,
      },
      wrap = false,
      bib = {
        default_path = nil,
        find_in_root = true,
      },
      silent = false,
      cursor = {
        jump_patterns = nil,
      },
      links = {
        style = "markdown",
        name_is_source = false,
        conceal = false,
        context = 0,
        implicit_extension = nil,
        transform_implicit = false,
        transform_explicit = function(text)
          text = text:gsub(" ", "-")
          text = text:lower()
          text = os.date "%Y-%m-%d_" .. text
          return text
        end,
        create_on_follow_failure = true,
      },
      new_file_template = {
        use_template = false,
        placeholders = {
          before = {
            title = "link_title",
            date = "os_date",
          },
          after = {},
        },
        template = "# {{ title }}",
      },
      to_do = {
        symbols = { " ", "-", "X" },
        update_parents = true,
        not_started = " ",
        in_progress = "-",
        complete = "X",
      },
      foldtext = {
        object_count = true,
        object_count_icons = "emoji",
        object_count_opts = function()
          return require("mkdnflow").foldtext.default_count_opts()
        end,
        line_count = true,
        line_percentage = true,
        word_count = false,
        title_transformer = nil,
        separator = " · ",
        fill_chars = {
          left_edge = "⢾",
          right_edge = "⡷",
          left_inside = " ⣹",
          right_inside = "⣏ ",
          middle = "⣿",
        },
      },
      tables = {
        trim_whitespace = true,
        format_on_move = true,
        auto_extend_rows = false,
        auto_extend_cols = false,
        style = {
          cell_padding = 1,
          separator_padding = 1,
          outer_pipes = true,
          mimic_alignment = true,
        },
      },
      yaml = {
        bib = { override = false },
      },
      mappings = {
        MkdnEnter = { { "i", "n", "v" }, "<CR>" },
        MkdnTab = { { "i", "x" }, "<Tab>" },
        MkdnSTab = { { "i", "x" }, "<S-Tab>" },
        MkdnNextLink = { "n", "<Tab>" },
        MkdnPrevLink = { "n", "<S-Tab>" },
        MkdnNextHeading = { "n", "]]" },
        MkdnPrevHeading = { "n", "[[" },
        MkdnGoBack = { "n", "<BS>" },
        MkdnGoForward = { "n", "<Del>" },
        MkdnCreateLink = false, -- see MkdnEnter
        MkdnCreateLinkFromClipboard = { { "n", "v" }, "<leader>p" }, -- see MkdnEnter
        MkdnFollowLink = false, -- see MkdnEnter
        MkdnDestroyLink = { "n", "<M-CR>" },
        MkdnTagSpan = { "v", "<M-CR>" },
        MkdnMoveSource = { "n", "<F2>" },
        MkdnYankAnchorLink = { "n", "yaa" },
        MkdnYankFileAnchorLink = { "n", "yfa" },
        MkdnIncreaseHeading = { "n", "+" },
        MkdnDecreaseHeading = { "n", "-" },
        MkdnToggleToDo = { { "n", "v" }, "<C-Space>" },
        MkdnNewListItem = false,
        MkdnNewListItemBelowInsert = { "n", "o" },
        MkdnNewListItemAboveInsert = { "n", "O" },
        MkdnExtendList = false,
        MkdnUpdateNumbering = { "n", "<leader>nn" },
        MkdnTableNextCell = false,
        MkdnTablePrevCell = false,
        MkdnTableNextRow = false,
        MkdnTablePrevRow = { "i", "<M-CR>" },
        MkdnTableNewRowBelow = { "n", "<leader>ir" },
        MkdnTableNewRowAbove = { "n", "<leader>iR" },
        MkdnTableNewColAfter = { "n", "<leader>ic" },
        MkdnTableNewColBefore = { "n", "<leader>iC" },
        MkdnFoldSection = { "n", "<leader>f" },
        MkdnUnfoldSection = { "n", "<leader>F" },
      },
    },
  },
  -- {
  --   "bullets-vim/bullets.vim",
  --   config = function()
  --     vim.g.bullets_enabled_file_types = { "octo", "markdown", "text" }
  --     vim.g.bullets_set_mappings = 0
  --     vim.g.bullets_custom_mappings = {
  --       { "imap", "<cr>", "<Plug>(bullets-newline)" },
  --       { "nmap", "o", "<Plug>(bullets-newline)" },
  --       { "vmap", "gN", "<Plug>(bullets-renumber)" },
  --       { "nmap", "gN", "<Plug>(bullets-renumber)" },
  --       { "nmap", "<leader>x", "<Plug>(bullets-toggle-checkbox)" },
  --       { "imap", "<Tab>", "<Plug>(bullets-demote)" },
  --       { "nmap", ">>", "<Plug>(bullets-demote)" },
  --       { "vmap", ">", "<Plug>(bullets-demote)" },
  --       { "imap", "<S-Tab>", "<Plug>(bullets-promote)" },
  --       { "nmap", "<<", "<Plug>(bullets-promote)" },
  --       { "vmap", "<", "<Plug>(bullets-promote)" },
  --     }
  --     print(vim.inspect(vim.g.bullets_custom_mappings))
  --     vim.g.bullets_pad_right = 0 -- no extra space between bullet and text
  --     vim.g.bullets_auto_indent_after_colon = 1
  --     vim.g.bullets_outline_levels = { "std-", "std-", "std-" }
  --     vim.g.bullets_renumber_on_change = 1
  --     vim.g.bullets_nested_checkboxes = 1
  --     vim.g.bullets_checkbox_markers = " X"
  --   end,
  -- },
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    -- keys = {
    --   { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    -- },
    opts = {
      symbol_folding = {
        autofold_depth = false,
      },
    },
  },
  {
    "3rd/image.nvim",
    config = function()
      require("image").setup {
        backend = "kitty",
        kitty_method = "normal",
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = true,
            filetypes = { "markdown", "vimwiki", "octo" },
          },
          neorg = {
            enabled = false,
          },
          html = {
            enabled = true,
          },
          css = {
            enabled = true,
          },
        },
        max_width = nil,
        max_height = nil,
        max_width_window_percentage = nil,

        -- This is what I changed to make my images look smaller, like a
        -- thumbnail, the default value is 50
        -- max_height_window_percentage = 20,
        max_height_window_percentage = 40,

        -- toggles images when windows are overlapped
        window_overlap_clear_enabled = false,
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },

        -- auto show/hide images when the editor gains/looses focus
        editor_only_render_when_focused = true,

        -- auto show/hide images in the correct tmux window
        -- In the tmux.conf add `set -g visual-activity off`
        tmux_show_only_in_active_window = true,

        -- render image files as images when opened
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
      }
    end,
  },
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      default = {

        -- file and directory options
        -- expands dir_path to an absolute path
        -- When you paste a new image, and you hover over its path, instead of:
        -- test-images-img/2024-06-03-at-10-58-55.webp
        -- You would see the entire path:
        -- /Users/linkarzu/github/obsidian_main/999-test/test-images-img/2024-06-03-at-10-58-55.webp
        --
        -- IN MY CASE I DON'T WANT TO USE ABSOLUTE PATHS
        -- if I switch to another computer and I have a different username,
        -- therefore a different home directory, that's a problem because the
        -- absolute paths will be pointing to a different directory
        use_absolute_path = false, ---@type boolean

        -- make dir_path relative to current file rather than the cwd
        -- To see your current working directory run `:pwd`
        -- So if this is set to false, the image will be created in that cwd
        -- In my case, I want images to be where the file is, so I set it to true
        relative_to_current_file = true, ---@type boolean

        -- I want to save the images in a directory named after the current file,
        -- but I want the name of the dir to end with `-img`
        dir_path = function()
          return vim.fn.expand "%:t:r" .. "-img"
        end,

        prompt_for_file_name = false, ---@type boolean
        file_name = "%Y-%m-%d-at-%H-%M-%S", ---@type string

        -- -- Set the extension that the image file will have
        -- -- I'm also specifying the image options with the `process_cmd`
        -- -- Notice that I HAVE to convert the images to the desired format
        -- -- If you don't specify the output format, you won't see the size decrease

        -- extension = "avif", ---@type string
        -- process_cmd = "convert - -quality 75 avif:-", ---@type string

        -- extension = "webp", ---@type string
        -- process_cmd = "convert - -quality 75 webp:-", ---@type string

        -- extension = "png", ---@type string
        -- process_cmd = "convert - -quality 75 png:-", ---@type string

        -- extension = "jpg", ---@type string
        -- process_cmd = "convert - -quality 75 jpg:-", ---@type string

        -- -- Here are other conversion options to play around
        -- -- Notice that with this other option you resize all the images
        -- process_cmd = "convert - -quality 75 -resize 50% png:-", ---@type string

        -- -- Other parameters I found in stackoverflow
        -- -- https://stackoverflow.com/a/27269260
        -- --
        -- -- -depth value
        -- -- Color depth is the number of bits per channel for each pixel. For
        -- -- example, for a depth of 16 using RGB, each channel of Red, Green, and
        -- -- Blue can range from 0 to 2^16-1 (65535). Use this option to specify
        -- -- the depth of raw images formats whose depth is unknown such as GRAY,
        -- -- RGB, or CMYK, or to change the depth of any image after it has been read.
        -- --
        -- -- compression-filter (filter-type)
        -- -- compression level, which is 0 (worst but fastest compression) to 9 (best but slowest)
        -- process_cmd = "convert - -depth 24 -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 png:-",
        --
        -- -- These are for jpegs
        -- process_cmd = "convert - -sampling-factor 4:2:0 -strip -interlace JPEG -colorspace RGB -quality 75 jpg:-",
        -- process_cmd = "convert - -strip -interlace Plane -gaussian-blur 0.05 -quality 75 jpg:-",
        --
      },

      filetypes = {
        markdown = {
          url_encode_path = true, ---@type boolean

          -- -- The template is what specifies how the alternative text and path
          -- -- of the image will appear in your file
          --
          -- -- $CURSOR will paste the image and place your cursor in that part so
          -- -- you can type the "alternative text", keep in mind that this will
          -- -- not affect the name that the image physically has
          -- template = "![$CURSOR]($FILE_PATH)", ---@type string
          --
          -- -- This will just statically type "Image" in the alternative text
          -- template = "![Image]($FILE_PATH)", ---@type string
          --
          -- -- This will dynamically configure the alternative text to show the
          -- -- same that you configured as the "file_name" above
          template = "![$FILE_NAME]($FILE_PATH)", ---@type string
        },
      },
    },
    keys = {
      -- suggested keymap
      -- { "<leader>v", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    },
  },
  {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      vim.cmd [[highlight Headline1 guifg=#f38ba8 guibg=#453244]]
      vim.cmd [[highlight Headline2 guifg=#fab387 guibg=#46393E]]
      vim.cmd [[highlight Headline3 guifg=#f9e2af guibg=#464245]]
      vim.cmd [[highlight Headline4 guifg=#a6e3a1 guibg=#374243]]
      vim.cmd [[highlight Headline5 guifg=#74c7ec guibg=#2E3D51]]
      vim.cmd [[highlight Headline6 guifg=#b4befe guibg=#393B54]]

      -- Defines the codeblock background color to something darker
      vim.cmd [[highlight CodeBlock guibg=#09090d]]
      -- When you add a line of dashes with --- this specifies the color, I'm not
      -- adding a "guibg" but you can do so if you want to add a background color
      vim.cmd [[highlight Dash guifg=white]]

      -- Setup headlines.nvim with the newly defined highlight groups
      require("headlines").setup {
        markdown = {
          fat_headlines = false,
          headline_highlights = {
            "Headline1",
            "Headline2",
            "Headline3",
            "Headline4",
            "Headline5",
            "Headline6",
          },
          bullets = { "󰎤", "󰎧", "󰎪", "󰎭", "󰎱", "󰎳" },
          bullet_highlights = {
            "Headline1",
            "Headline2",
            "Headline3",
            "Headline4",
            "Headline5",
            "Headline6",
          },
        },
      }
    end,
  },
}
