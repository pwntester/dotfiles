-- from statuscol.nvim
-- https://github.com/luukvbaal/statuscol.nvim/blob/559b16b9e0a1374699ad1889d77aa8ebf844363b/lua/statuscol/ffidef.lua
local ffi = require("ffi")
ffi.cdef([[
  typedef struct window_S win_T;
	typedef struct foldinfo {
	  int start;  // line number where deepest fold starts
	  int level;  // fold level, when zero other fields are N/A
	  int llevel; // lowest level that starts in v:lnum
	  int lines;  // number of lines from v:lnum to end of closed fold
	} foldinfo_T;
	foldinfo_T fold_info(win_T* wp, int lnum);
  typedef struct {} Error;
  win_T *find_window_by_handle(int Window, Error *err);
	int compute_foldcolumn(win_T *wp, int col);
]])

return ffi
