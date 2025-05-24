local M = {}

-- 連続した文字列（内部にスペースがないと仮定）を表示幅で分割するヘルパー関数。
-- 各部分は最大幅以下の表示幅を持つ。ただし、1文字自体が最大幅より広い場合はその文字が1つの部分となる。
---@param token_str string : 分割する文字列。
---@param max_width_val number : 幅
---@return table string[] : 分割された文字列のリスト。各部分は最大幅以下の表示幅を持つ。
function M.break_string_by_display_width(token_str, max_width_val)
  local parts_tbl = {}
  if token_str == nil or token_str == "" then return parts_tbl end

  local current_part_str = ""
  local current_part_display_width = 0
  local byte_pointer = 1

  while byte_pointer <= #token_str do
    local current_char_byte_len = 1
    local first_byte_val = string.byte(token_str, byte_pointer)

    if not first_byte_val then break end -- 文字列の終端

    -- 最初のバイトからUTF-8文字のバイト長を決定
    if first_byte_val >= 240 then -- 0xF0 (4バイトシーケンス)
      current_char_byte_len = 4
    elseif first_byte_val >= 224 then -- 0xE0 (3バイトシーケンス)
      current_char_byte_len = 3
    elseif first_byte_val >= 192 then -- 0xC0 (2バイトシーケンス)
      current_char_byte_len = 2
    else -- 1バイトシーケンス
      current_char_byte_len = 1
    end

    -- 不正なUTF-8シーケンスの場合に文字列の終端を超えて読み取らないようにする
    if byte_pointer + current_char_byte_len - 1 > #token_str then
      current_char_byte_len = #token_str - byte_pointer + 1
    end

    local current_char_str = string.sub(token_str, byte_pointer, byte_pointer + current_char_byte_len - 1)

    -- 何らかの理由で空の文字が生成された場合（例：予期せず文字列の終端に達した）は中断
    if current_char_str == "" then break end

    local current_char_display_width = vim.fn.strdisplaywidth(current_char_str)

    if current_part_display_width + current_char_display_width <= max_width_val then
      current_part_str = current_part_str .. current_char_str
      current_part_display_width = current_part_display_width + current_char_display_width
    else
      -- 現在の文字を current_part_str に追加できない
      if current_part_str ~= "" then table.insert(parts_tbl, current_part_str) end

      -- current_char_str で新しい部分を開始
      if current_char_display_width <= max_width_val then
        current_part_str = current_char_str
        current_part_display_width = current_char_display_width
      else
        -- current_char_str 自体が max_width_val より広い。
        -- それ自体を1つの部分として追加し、次の文字のために current_part_str をリセット。
        table.insert(parts_tbl, current_char_str)
        current_part_str = ""
        current_part_display_width = 0
      end
    end
    byte_pointer = byte_pointer + current_char_byte_len
  end

  -- 残りの部分があれば追加
  if current_part_str ~= "" then table.insert(parts_tbl, current_part_str) end

  return parts_tbl
end

-- 指定されたテキスト文字列を、指定された表示幅に収まるように単語単位で改行します。
---@param text_to_wrap string : 改行するテキスト文字列。
---@param max_line_display_width number : 各行の最大表示幅。
---@return table string[] : 文字列のリスト。各文字列は改行された行を表します。
function M.WrapTextByWordsAndDisplayWidth(text_to_wrap, max_line_display_width)
  -- nil入力を適切に処理
  if text_to_wrap == nil then
    return { "" } -- 空文字列1つを含むテーブルを返す
  end

  -- 0以下のmax_line_display_widthのエッジケースを処理:
  -- これはテキストを個々のUTF-8文字に分割します。
  if max_line_display_width <= 0 then
    if text_to_wrap == "" then return { "" } end
    local character_lines = {}
    local byte_ptr = 1
    while byte_ptr <= #text_to_wrap do
      local char_len = 1
      local first_byte = string.byte(text_to_wrap, byte_ptr)
      if not first_byte then break end

      if first_byte >= 240 then
        char_len = 4
      elseif first_byte >= 224 then
        char_len = 3
      elseif first_byte >= 192 then
        char_len = 2
        -- else char_len は 1 のまま
      end

      if byte_ptr + char_len - 1 > #text_to_wrap then char_len = #text_to_wrap - byte_ptr + 1 end

      local char_s = string.sub(text_to_wrap, byte_ptr, byte_ptr + char_len - 1)
      if char_s == "" then break end -- 安全のためのブレーク
      table.insert(character_lines, char_s)
      byte_ptr = byte_ptr + char_len
    end
    return character_lines
  end

  local resulting_lines_tbl = {}
  local current_line_str_buffer = ""
  local current_line_display_width_val = 0

  -- 1つ以上の空白文字を区切り文字としてテキストを単語に分割します。
  -- この方法は、元のテキストの先頭/末尾の空白を本質的にトリムし、
  -- 単語間の複数のスペースを再結合時に単一のスペースに圧縮します。
  local words_list_tbl = {}
  for matched_word_str in string.gmatch(text_to_wrap, "%S+") do -- %S+ は非空白文字にマッチ
    table.insert(words_list_tbl, matched_word_str)
  end

  if #words_list_tbl == 0 then -- 入力テキストが空か、空白のみを含む場合。
    if text_to_wrap == "" then return { "" } end
    -- 空白のみで構成されるテキストの場合、幅で分割します。
    return M.break_string_by_display_width(text_to_wrap, max_line_display_width)
  end

  for _, current_word_str in ipairs(words_list_tbl) do
    local current_word_display_width = vim.fn.strdisplaywidth(current_word_str)

    if current_line_str_buffer == "" then
      -- 現在の行の最初の単語。
      if current_word_display_width <= max_line_display_width then
        current_line_str_buffer = current_word_str
        current_line_display_width_val = current_word_display_width
      else
        -- 単語自体が新しい行には長すぎるため、分割する必要がある。
        local broken_word_parts_tbl = M.break_string_by_display_width(current_word_str, max_line_display_width)
        for j, part_str_val in ipairs(broken_word_parts_tbl) do
          if j < #broken_word_parts_tbl then
            table.insert(resulting_lines_tbl, part_str_val) -- 最後以外の部分を直接行に追加
          else
            -- 分割された単語の最後の部分が新しい current_line_str_buffer を開始
            current_line_str_buffer = part_str_val
            current_line_display_width_val = vim.fn.strdisplaywidth(part_str_val)
          end
        end
      end
    else
      -- current_line_str_buffer に内容がある。新しい current_word_str を先行するスペースとともに追加しようと試みる。
      local space_char_display_width = vim.fn.strdisplaywidth(" ")
      if
        current_line_display_width_val + space_char_display_width + current_word_display_width <= max_line_display_width
      then
        current_line_str_buffer = current_line_str_buffer .. " " .. current_word_str
        current_line_display_width_val = current_line_display_width_val
          + space_char_display_width
          + current_word_display_width
      else
        -- " " + current_word_str のための十分なスペースがない。current_line_str_buffer を確定。
        table.insert(resulting_lines_tbl, current_line_str_buffer)

        -- current_word_str で新しい行を開始。
        if current_word_display_width <= max_line_display_width then
          current_line_str_buffer = current_word_str
          current_line_display_width_val = current_word_display_width
        else
          -- この新しい current_word_str 自体が新しい行には長すぎるため、分割。
          local broken_word_parts_tbl = M.break_string_by_display_width(current_word_str, max_line_display_width)
          for j, part_str_val in ipairs(broken_word_parts_tbl) do
            if j < #broken_word_parts_tbl then
              table.insert(resulting_lines_tbl, part_str_val)
            else
              current_line_str_buffer = part_str_val
              current_line_display_width_val = vim.fn.strdisplaywidth(part_str_val)
            end
          end
        end
      end
    end
  end

  -- 最後に蓄積された行があれば追加。
  if current_line_str_buffer ~= "" then table.insert(resulting_lines_tbl, current_line_str_buffer) end

  -- 元のテキストが空でなく、処理の結果として行のリストが空になった場合
  -- (例：テキストがすべてスペースで #words_list_tbl が0だった場合、これは前のチェックで処理される)、
  -- 入力テキスト自体が空文字列だった場合に少なくとも1つの空文字列の行を保証します。
  if #resulting_lines_tbl == 0 and text_to_wrap == "" then return { "" } end

  return resulting_lines_tbl
end

---@param msg string
---@param code string
---@param width number max_line_length
---@return string warapped_msg
function M.wrap_text(msg, code, width)
  local count = vim.fn.strdisplaywidth
  local msg_width = count(msg)
  local code_width = count(code)

  if not msg or msg_width + code_width + 1 < width then return msg .. " " .. code end
  if msg_width <= width then return msg .. "\n" .. code end

  local lines = M.WrapTextByWordsAndDisplayWidth(msg, width)
  if vim.fn.strdisplaywidth(lines[#lines]) + code_width + 1 <= width then
    lines[#lines] = lines[#lines] .. " " .. code
  else
    table.insert(lines, code)
  end
  return table.concat(lines, "\n")
end

---@param diagnostic vim.Diagnostic
---@return string フォーマットされた診断メッセージ
function M.format_diagnostic_message(diagnostic)
  local message = diagnostic.message
  local source = diagnostic.source
  local code = diagnostic.code or nil
  local col = diagnostic.col
  local win_width = vim.api.nvim_win_get_width(0)
  local bufnr = diagnostic.bufnr

  if bufnr then
    local win_ids = vim.fn.win_findbuf(bufnr)
    for _, win_id in ipairs(win_ids) do
      if win_width > vim.api.nvim_win_get_width(win_id) then win_width = vim.api.nvim_win_get_width(win_id) end
    end
  end

  local code_str
  if code then
    code_str = string.format("(%s: %s)", source, code)
  elseif source then
    code_str = string.format("(%s)", source)
  else
    code_str = ""
  end

  -- 1行の最大文字数を設定
  local wrap_width = win_width - col

  -- メッセージ部分を折り返す
  local wrapped_message = M.wrap_text(message, code_str, wrap_width)
  return wrapped_message
end

return M
