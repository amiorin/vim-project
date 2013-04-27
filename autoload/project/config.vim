let s:projects = {}

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
  let s:projects[title] = { "type": "project", "event": event, "project": project, "title": title, "callbacks": [] }
  call s:setup()
endfunction

function! project#config#callback(title, callback) abort
  if type(a:callback) == type([])
    let callbacks = a:callback
  else
    let callbacks = [a:callback]
  endif
  let project_or_filename = s:projects[a:title]
  for callback in callbacks
    call add(project_or_filename["callbacks"], callback)
  endfor
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
    let s:projects[a:title] = { "type": "filename", "event": filename, "title": a:title, "callbacks": [] }
    call s:setup()
  endif
endfunction

function! project#config#project_path(arg, ...) abort
  if len(a:000) > 0
    call project#config#project(a:arg, a:1)
  else
    call project#config#project(a:arg)
  endif
endfunction

function! s:callback(title) abort
  let project = s:projects[a:title]
  let type = project["type"]
  let callbacks = project["callbacks"]
  if len(callbacks) > 0
    for callback in callbacks
      execute "call ".callback."(\"".a:title."\")"
    endfor
  endif
endfunction

function! s:setup() abort
  augroup vim_project
    autocmd!
    for v in values(s:projects)
      if v["type"] == "project"
        let autocmd = "autocmd BufEnter ".v["event"]." lcd ".v["project"]." | let b:title = \"".v["title"]."\" | call s:callback(\"".v["title"]."\")"
      else
        let autocmd = "autocmd BufEnter ".v["event"]." let b:title = \"".v["title"]."\" | call s:callback(\"".v["title"]."\")"
      endif
      execute autocmd
    endfor
    if has("gui_running")
      au BufEnter,BufRead,WinEnter * call TabTitle()
      au BufEnter,BufRead,WinEnter * let &titlestring = getcwd()
    endif
  augroup END
endfunction
