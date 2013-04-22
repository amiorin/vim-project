function! project#config#project(arg, ...) abort
  if a:arg[0] == "/" || a:arg[0] == "~"
    let project = resolve(fnamemodify(a:arg, ":p"))
  else
    let project = resolve(fnamemodify(g:project_dir."/".a:arg, ":p"))
  endif
  if len(a:000) > 0
    let title = a:1
  else
    let title = fnamemodify(project, ":t")
  endif
  let event = project."/*"
  if !isdirectory(project)
    return
  endif
  let autocmd = "autocmd BufEnter ".event." lcd ".project." | let b:title = \"".title."\""
  call add(g:projects, autocmd)
  call s:setup()
endfunction

function! project#config#title(filename, title) abort
  let filename = resolve(fnamemodify(a:filename, ":p"))
  if !filereadable(filename)
    let filename = resolve(fnamemodify(g:project_dir."/".a:filename, ":p"))
  endif
  if !filereadable(filename)
    return
  else
    let autocmd = "autocmd BufEnter ".filename." let b:title = \"".a:title."\""
    call add(g:projects, autocmd)
    call s:setup()
  endif
endfunction

function! project#config#project_path(arg, ...) abort
  if len(a:000) > 0
    call project#config#project(arg, title)
  else
    call project#config#project(arg)
  endif
endfunction

function! s:setup() abort
  augroup vim_project
    autocmd!
    for autocmd in g:projects
      execute autocmd
    endfor
    if has("gui_running")
      au BufEnter,BufRead,WinEnter * call TabTitle()
      au BufEnter,BufRead,WinEnter * let &titlestring = getcwd()
    endif
  augroup END
endfunction
