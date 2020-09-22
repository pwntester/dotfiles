local vim = vim
local base16 = require 'base16'

local function hl(group, guifg, guibg, ctermfg, ctermbg, attr, guisp)
	local parts = {group}
	if guifg then table.insert(parts, "guifg=#"..guifg) end
	if guibg then table.insert(parts, "guibg=#"..guibg) end
	if ctermfg then table.insert(parts, "ctermfg="..ctermfg) end
	if ctermbg then table.insert(parts, "ctermbg="..ctermbg) end
	if attr then
		table.insert(parts, "gui="..attr)
		table.insert(parts, "cterm="..attr)
	end
	if guisp then table.insert(parts, "guisp=#"..guisp) end

	local cmd = 'highlight '..table.concat(parts, ' ')
	vim.api.nvim_command(cmd)
end

local M = {}

function M.setup()
	vim.cmd [[ syntax enable ]]
	vim.cmd [[ set background=dark ]]
	vim.cmd [[ hi clear markdownCode ]]
	vim.cmd [[ augroup theme ]]
	vim.cmd [[ autocmd! ]]
	vim.cmd [[ autocmd ColorScheme * lua require'theme'.norcalli() ]]
	vim.cmd [[ augroup END ]]
	vim.cmd [[ colorscheme default ]]
end

function M.cobange()
    local cobange = {
        '#101a20'; '#1b2b34'; '#17252c'; '#0050A4';
        '#00AAFF'; '#444444'; '#626262'; '#CCCCCC';
        '#FF0000'; '#FF9A00'; '#FFC600'; '#99c794';
        '#668799'; '#80FCFF'; '#EB939A'; '#FF628C';
    }

	local colors = vim.tbl_map(function(v) return string.gsub(v, '#', '') end , cobange)

	local theme = base16.theme_from_array(colors)
    base16(theme, true)
end

function M.norcalli()

    local norcalli = {
		--'#111b2b'; '#213554'; '#1d3872'; '#80b2d6';
        '#0b1f41'; '#11305f'; '#3a5488'; '#80b2d6';
        '#3aa3e9'; '#abb2bf'; '#b6bdca'; '#c8ccd4';
        '#f04c75'; '#d19a66'; '#e5c07b'; '#98c379';
        '#56b6c2'; '#01bfef'; '#c678dd'; '#be5046';
    }

	local colors = vim.tbl_map(function(v) return string.gsub(v, '#', '') end , norcalli)

	local theme = base16.theme_from_array(colors)
    base16(theme, true)

	hl('NormalFloat',				theme.base05, theme.base00)
	hl('NormalNC',					nil,		  theme.base01)
	hl('LineNr',					theme.base02, theme.base00)
	hl('LineNrNC',					theme.base02, theme.base01)
	hl('StatusLine',				theme.base02, theme.base00)
	hl('StatusLineNC',				theme.base02, theme.base00)
    hl('EndOfBuffer',				theme.base01, theme.base00)
    hl('EndOfBufferNC',				theme.base01, theme.base01)
	hl('SignColumn',				theme.base01, theme.base00)
	hl('VertSplit',					theme.base02, theme.base00)
	hl('ColorColumn',				theme.base01, theme.base01)

	hl('PopupWindowBorder',			theme.base01, theme.base00)
	hl('InvertedPopupWindowBorder', theme.base00, theme.base01)

    hl('MyStatuslineSeparator',     theme.base00, theme.base00)
    hl('MyStatuslineBar',          	theme.base00, theme.base00)
    hl('MyStatuslineGit',          	theme.base07, theme.base00)
    hl('MyStatuslineFiletype',     	theme.base03, theme.base00)
    hl('MyStatuslinePercentage',   	theme.base03, theme.base00)
    hl('MyStatuslineLineCol',      	theme.base03, theme.base00)
    hl('MyStatuslineLSPErrors',    	theme.base08, theme.base00)
    hl('MyStatuslineLSPWarnings',  	theme.base15, theme.base00)
    hl('MyStatuslineLSP',          	theme.base03, theme.base00)
    hl('MyStatuslineBarNC',        	theme.base00, theme.base01)

    hl('TabLineSel',				theme.base08, theme.base01)

	hl('MatchParen',                theme.base07, theme.base08)

	hl('markdownCode',				nil,		  theme.base01)

-- LspDiagnosticsError                 red         none
-- LspDiagnosticsWarning               yellow      none
-- LspDiagnosticsInformation           blue        none
-- LspDiagnosticsHint                  blue        none
-- LspDiagnosticsUnderline             none        none        undercurl       guisp=white
-- LspDiagnosticsUnderlineError        none        none        undercurl       guisp=red
-- LspDiagnosticsUnderlineWarning      none        none        undercurl       guisp=yellow
-- LspDiagnosticsUnderlineInformation  none        none        undercurl       guisp=blue
-- LspDiagnosticsUnderlineHint         none        none        undercurl       guisp=blue
-- LspReferenceText                    none        darker_grey bold,italic
-- LspReferenceRead                    none        darker_grey bold,italic
-- LspReferenceWrite                   none        darker_grey bold,italic
end


return M