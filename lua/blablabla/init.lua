local M = {}
-- fetches anthropic api key from environment.
-- replaces the vim visually selected text with the provided content
local function replace_text(replacement)
  if not replacement then return end
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_row = start_pos[2] - 1
  local end_row = end_pos[2]
  local replacement_lines = vim.split(replacement, "\n")
  vim.api.nvim_buf_set_lines(0, start_row, end_row, false, replacement_lines)
end
local notify = vim.notify
local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }
local current_spinner = nil
local spinner_timer = nil
local function create_spinner_notification()
  local frame_index = 1
  local notification_id = nil
  -- Create the initial notification
  notification_id = notify("Loading...", vim.log.levels.INFO, {
    icon = spinner_frames[frame_index],
    replace = notification_id
  })
  -- Create a timer for updating the spinner
  spinner_timer = vim.loop.new_timer()
  if spinner_timer == nil then
    return
  end
  spinner_timer:start(0, 100, vim.schedule_wrap(function()
    frame_index = (frame_index % #spinner_frames) + 1
    notification_id = notify("Loading...", vim.log.levels.INFO, {
      icon = spinner_frames[frame_index],
      replace = notification_id
    })
    current_spinner = notification_id
  end))
  return notification_id
end
local function stop_spinner()
  if spinner_timer then
    spinner_timer:stop()
    spinner_timer:close()
    spinner_timer = nil
  end
  if current_spinner then
    -- Instead of using notify_dismiss, we'll replace the spinner with an empty notification
    notify("", vim.log.levels.INFO, {
      replace = current_spinner,
      timeout = 1, -- This should make it disappear immediately
      hide_from_history = true
    })
    current_spinner = nil
  end
end
---@return nil
function M.Comment()
  -- Start the spinner
  create_spinner_notification()
  local work = vim.uv.new_work(function()
    -- use vim runtime / global to return the content in the area captured by a visual block
    local function get_highlighted_text()
      local start_pos = vim.fn.getpos("'<")
      local end_pos = vim.fn.getpos("'>")
      vim.notify("Start pos: " .. vim.inspect(start_pos))
      vim.notify("End pos: " .. vim.inspect(end_pos))
      local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
      vim.notify("Lines retrieved: " .. vim.inspect(lines))
      if #lines == 0 then
        vim.notify("No lines retrieved", vim.log.levels.WARN)
        return nil
      end
      -- Handle visual block selection
      if vim.fn.visualmode() == "\22" then
        local start_col = start_pos[3]
        local end_col = end_pos[3]
        vim.notify(string.format("Visual block mode: cols %d to %d", start_col, end_col))
        for i, line in ipairs(lines) do
          lines[i] = string.sub(line, start_col, end_col)
        end
      end
      local result = table.concat(lines, "\n")
      vim.notify("Final result: " .. result)
      return result
    end
    local prompt = [[
  I will provide you with a block of code. Return ONLY the exact code with documentation comments. DO NOT include any markdown formatting, backticks, or extra text:
  1. Add clear documentation comments above functions and blocks
  2. Include parameters and return types for functions
  3. Keep original formatting and indentation exactly as provided
  4. Only add line comments when needed for clarity
  5. Be concise and clear
  6. IMPORTANT: Return the raw code only - no backticks, no markdown, no formatting
  7. Preserve all aspects of the input text exactly, only adding comments
  8. Do not include inline comments unless absolutely necessary
  9. Preserve all single quotes exactly as they appear
  10. Preserve all indentation exactly as provided
  11. DO NOT wrap the response in any kind of code block or formatting
  12. The response should start immediately with the code and end with the last line of code
  Here is the code to document:
  ]]
    local function ask_model(input_text)
      local api_key = os.getenv("ANTHROPIC_API_KEY")
      if not api_key then
        vim.notify("ANTHROPIC_API_KEY environment variable not set", vim.log.levels.ERROR)
        return nil
      end
      local json_data = vim.json.encode({
        model = "claude-3-sonnet-20240229",
        max_tokens = 1024,
        messages = {
          { role = "user", content = prompt .. input_text }
        }
      })
      local response = require('plenary.curl')
          .post('https://api.anthropic.com/v1/messages',
            {
              headers = {
                ['x-api-key'] = api_key,
                ['anthropic-version'] = '2023-06-01',
                ['content-type'] = 'application/json'
              },
              body = json_data
            })
      if response == nil then
        return nil
      end
      vim.notify(vim.inspect(response))
      local parsed = vim.json.decode(response.body)
      return parsed.content[1].text
    end
    local text = get_highlighted_text()
    local response = ask_model(text)
    if response and not response.error then
      replace_text(response)
    end
  end, stop_spinner)
  work:queue()
end
return M
