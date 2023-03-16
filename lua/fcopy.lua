local fcopy = {}

local start_position = nil

function fcopy.start()
  start_position = vim.api.nvim_win_get_cursor(0)
end

local function get_visual_selection()
  -- this will exit visual mode
  -- use 'gv' to reselect the text
  local _, csrow, cscol, cerow, cecol
  local mode = vim.fn.mode()
  if mode == 'v' or mode == 'V' or mode == '' then
    -- if we are in visual mode use the live position
    _, csrow, cscol, _ = unpack(vim.fn.getpos("."))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("v"))
    if mode == 'V' then
      -- visual line doesn't provide columns
      cscol, cecol = 0, 999
    end
    -- exit visual mode
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<Esc>",
        true, false, true), 'n', true)
  else
    -- otherwise, use the last known visual position
    _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  end

  -- swap vars if needed
  if cerow < csrow then csrow, cerow = cerow, csrow end
  if cecol < cscol then cscol, cecol = cecol, cscol end

  -- Check if there's any selected text
  if csrow == cerow and cscol == cecol then
    return nil
  end

  local lines = vim.fn.getline(csrow, cerow)
  local n = cerow - csrow + 1
  if n <= 0 then return nil end


  lines[n] = string.sub(lines[n], 1, cecol)
  lines[1] = string.sub(lines[1], cscol)
  return table.concat(lines, "\n")
end

function fcopy.end_()
  if start_position then
    local selected_text = get_visual_selection()

    if selected_text then
      -- Paste the copied text at the saved start_position
      vim.api.nvim_win_set_cursor(0, start_position)
      vim.fn.setreg('"', selected_text, 'V')
      vim.cmd('normal! p')
      start_position = nil
    else
      print("No text is selected. Please select text in visual mode.")
      return
    end
  else
    print("Fcopy hasn't been started. Call ':FcopyStart' first.")
  end
end

return fcopy
