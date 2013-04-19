command! -nargs=+ Project
\ call project#config#project(<args>)

command! -complete=file -nargs=+ ProjectPath
\ call project#config#project_path(<f-args>)

if has("gui_running")
  function! TabTitle()
    let title = expand("%:p:t")
    let t:title = exists("b:title") ? b:title : title
  endfunction
  augroup vim_project
    au BufEnter,BufRead,WinEnter * call TabTitle()
    au BufEnter,BufRead,WinEnter * let &titlestring = getcwd()
  augroup END

  au VimEnter * set guitablabel=%-2.2N%{gettabvar(v:lnum,'title')}
  set showtabline=2
  set title
endif

function! project#rc(...) abort
  let g:project_dir = len(a:000) > 0 ? expand(a:1, 1) : expand('$HOME', 1)
endfunction
