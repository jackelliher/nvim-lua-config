local M = {}

function M.create_note()
  local notes_dir = os.getenv("zjnotes")

  if not notes_dir then
    vim.notify("Environment variable 'zjnotes' not found!", vim.log.levels.ERROR)
    return
  end

  -- Prompt user for filename
  vim.ui.input({
    prompt = "Enter note name: ",
  }, function(input)
    local date = os.date("%Y-%m-%d")
    local filename = input

    if not filename or filename == "" then
      filename = date .. ".md"
    elseif not filename:match("%.md$") then
      filename = filename .. ".md"
    end

    local full_path = notes_dir .. "/" .. filename

    -- Create the file
    local file = io.open(full_path, "w")
    if file then
      file:write("# " .. os.date("%Y-%m-%d %A") .. "\n\n")
      file:close()
      -- Open the file in a new split
      vim.cmd("split " .. full_path)
    else
      vim.notify("Failed to create note file!", vim.log.levels.ERROR)
    end
  end)
end

function M.search_note()
  local notes_dir = os.getenv("zjnotes")

  if not notes_dir then
    vim.notify("Environment variable 'zjnotes' not found!", vim.log.levels.ERROR)
    return
  end

  require('telescope.builtin').find_files({
    prompt_title = "Search Notes",
    cwd = notes_dir,
  })
end

function M.grep_notes()
  local notes_dir = os.getenv("zjnotes")

  if not notes_dir then
    vim.notify("Environment variable 'zjnotes' not found!", vim.log.levels.ERROR)
    return
  end

  require('telescope.builtin').live_grep({
    prompt_title = "Grep Notes",
    cwd = notes_dir,
  })
end

function M.setup()
  -- Create keybindings
  vim.keymap.set("n", "<leader>jz", M.create_note, { desc = "Create new note" })
  vim.keymap.set("n", "<leader>js", M.search_note, { desc = "Search notes" })
  vim.keymap.set("n", "<leader>jg", M.grep_notes, { desc = "Grep notes" })
end

return M
