" Zekai's Vim Setting
" Last Revised: Sep. 12, 2024

" {{{........clang-format
if has('python')
  map <C-K> :pyf /opt/homebrew/Cellar/clang-format/18.1.6/share/clang/clang-format.py<cr>
  imap <C-K> <c-o>:pyf /opt/homebrew/Cellar/clang-format/18.1.6/share/clang/clang-format.py<cr>
elseif has('python3')
  map <C-K> :py3f /opt/homebrew/Cellar/clang-format/18.1.6/share/clang/clang-format.py<cr>
  imap <C-K> <c-o>:py3f /opt/homebrew/Cellar/clang-format/18.1.6/share/clang/clang-format.py<cr>
endif
" }}}
