command! -nargs=+ Project
\ call project#config#project(<args>)

command! -nargs=+ File
\ call project#config#title(<args>)

command! -nargs=+ Callback
\ call project#config#callback(<args>)

command! -complete=file -nargs=+ ProjectPath
\ call project#config#project_path(<f-args>)

command! -nargs=0 -bar Welcome
\ enew | call project#config#welcome()

if has("gui_running")
  function! TabTitle()
    let title = expand("%:p:t")
    let t:title = exists("b:title") ? b:title : title
  endfunction

  au VimEnter * set guitablabel=%-2.2N%{gettabvar(v:lnum,'title')}
  set title
endif

if get(g:, 'project_enable_welcome', 1)
  au VimEnter *
        \ if !argc() && (line2byte('$') == -1) && (v:progname =~? '^[gm]\=vim\%[\.exe]$') |
        \   call project#config#welcome() |
        \ endif
endif

function! project#rc(...) abort
  let g:project_dir = len(a:000) > 0 ? expand(a:1, 1) : expand('$HOME', 1)
endfunction
