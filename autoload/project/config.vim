function! project#config#project(arg, ...)
  let arg = substitute(a:arg, "\/$", '', '')
  if len(a:000) > 0
    let title = a:1
  else
    let title = fnamemodify(arg, ":t")
  endif
  let project = g:project_dir."/".arg
  let event = project
  if isdirectory(project)
    let event = event."/*"
  elseif isdirectory(fnamemodify(arg, ":p"))
    let project = fnamemodify(arg, ":p")
    let event = project."*"
  elseif filereadable(project)
    let project = fnamemodify(project, ":p:h")
  elseif filereadable(fnamemodify(arg, ":p"))
    let project = fnamemodify(arg, ":p:h")
    let event = fnamemodify(arg, ":p")
  else
    return
  endif
  let autocmd = "autocmd BufEnter ".event." lcd ".project." | let b:title = \"".title."\""
  augroup vim_project
    execute autocmd
  augroup END
endfunction

function! project#config#project_path(arg, ...)
  let arg = substitute(a:arg, "\/$", '', '')
  if len(a:000) > 0
    let title = a:1
  else
    let title = fnamemodify(arg, ":t")
  endif
  call project#config#project(arg, title)
endfunction
