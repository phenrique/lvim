local function get_arduino_fqbn(inputstr)

  local t = {}
  for str in string.gmatch(inputstr, "([^:]+)") do
    table.insert(t, str)
  end

  local s = table.concat(t, ":", 1, 3)

  return s

end

local arduino_board_fqbn = get_arduino_fqbn(vim.g.arduino_board)

local function arduino_status()
  local ft = vim.api.nvim_buf_get_option(0, "ft")
  if ft ~= "arduino" then
    return ""
  end
  local port = vim.fn["arduino#GetPort"]()
  local line = string.format("[%s]", arduino_board_fqbn)
  if vim.g.arduino_programmer ~= "" then
    line = line .. string.format(" [%s]", vim.g.arduino_programmer)
  end
  if port ~= 0 then
    line = line .. string.format(" (%s:%s)", port, vim.g.arduino_serial_baud)
  end
  return line
end

local opts = {
  cmd = {
    "/usr/bin/arduino-language-server",
    "-clangd", "/home/paulo/.local/share/nvim/lsp_servers/clangd/clangd/bin/clangd",
    "-cli", "/usr/bin/arduino-cli",
    "-cli-config", "/home/paulo/.arduino15/arduino-cli.yaml",
    "-fqbn", arduino_board_fqbn
  }
}
require("lvim.lsp.manager").setup("arduino_language_server", opts)
--require("lspconfig")["arduino_language_server"].setup(opts)

--  local config = lualine.get_config()

lvim.builtin.lualine.sections.lualine_c = { arduino_status }

lvim.builtin.which_key.mappings["a"] = {
  name = "+Arduino",
  a = { "<cmd> ArduinoAttach<CR> ", "ArduinoAttach" },
  v = { "<cmd> ArduinoVerify<CR> ", "ArduinoVerify" },
  u = { "<cmd> ArduinoUpload<CR> ", "ArduinoUpload" },
  d = { "<cmd> ArduinoUploadAndSerial<CR> ", "ArduinoUploadAndSerial " },
  b = { "<cmd> ArduinoChooseBoard<CR> ", "ArduinoChooseBoard     " },
  p = { "<cmd> ArduinoChooseProgrammer<CR> ", "ArduinoChooseProgrammer" },
  i = { "<cmd> ArduinoInfo<CR> ", "ArduinoInfo            " },
}
