let s:projects = {}
let s:pos = 0

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
  let s:projects[title] = { "type": "project", "event": event, "project": project, "title": title, "callbacks": [], "pos": s:pos}
  let s:pos += 1
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
    let s:projects[a:title] = { "type": "filename", "event": filename, "title": a:title, "callbacks": [], "pos": s:pos }
    let s:pos += 1
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

function! project#config#get_sep() abort
  return !exists('+shellslash') || &shellslash ? '/' : '\'
endfunction

function! project#config#welcome() abort
  if !empty(v:servername) && exists('g:project_skiplist_server')
    for servname in g:project_skiplist_server
      if (servname == v:servername)
        return
      endif
    endfor
  endif
  setlocal nonumber noswapfile bufhidden=wipe
  if (v:version >= 703)
    setlocal norelativenumber
  endif
  if get(g:, 'project_unlisted_buffer', 1)
    setlocal nobuflisted
  endif
  setfiletype project

  let special = get(g:, 'project_enable_special', 1)
  let sep = project#config#get_sep()
  let cnt = 0

  if special
    call append('$', '   [e]  <empty buffer>')
  endif

  if special && len(s:projects)
    call append('$', '')
  endif

  let padding = '  '
  let projects = sort(values(s:projects), "s:sort")
  let max_title_length = 0
  let max_file_length = 0
  for v in projects
    if v["type"] == "project"
      let file = v["project"]
    else
      let file = v["event"]
    endif
    if len(file) > max_file_length
      let max_file_length = len(file)
    endif
    if len(v["title"]) > max_title_length
      let max_title_length = len(v["title"])
    endif
  endfor
  for v in projects
    if v["type"] == "project"
      let file = v["project"]
      let lcd = " \\| lcd ".v["project"]
    else
      let file = v["event"]
      let lcd = ""
    endif
    let line = printf(printf('   ['. cnt .']'.padding.'%s '.file, '%-'.max_title_length.'s'), v["title"])
    call append('$', line)
    execute 'nnoremap <buffer> '. cnt .' :edit '. s:escape(file).lcd."<cr>"
    let cnt += 1
    if cnt == 10
      let padding = ' '
    endif
  endfor

  if special
    call append('$', ['', '   [q]  <quit>'])
  endif

  setlocal nomodifiable nomodified

  nnoremap <buffer><silent> e :enew<cr>
  nnoremap <buffer><silent> i :enew <bar> startinsert<cr>
  nnoremap <buffer><silent> <cr> :normal <c-r><c-w><cr>
  nnoremap <buffer><silent> <2-LeftMouse> :execute 'normal '. matchstr(getline('.'), '\w\+')<cr>
  nnoremap <buffer><silent> q
        \ :if (len(filter(range(0, bufnr('$')), 'buflisted(v:val)')) > 1) <bar>
        \   bd <bar>
        \ else <bar>
        \   quit <bar>
        \ endif<cr>

  augroup welcome
    autocmd CursorMoved <buffer> call s:set_cursor()
  augroup END

  call cursor(special ? 4 : 2, 5)
endfunction

function! s:escape(path) abort
  return !exists('+shellslash') || &shellslash ? fnameescape(a:path) : escape(a:path, '\')
endfunction

function! s:set_cursor() abort
  let s:line_old = exists('s:line_new') ? s:line_new : 5
  let s:line_new = line('.')
  if empty(getline(s:line_new))
    if (s:line_new > s:line_old)
      let s:line_new += 1
      call cursor(s:line_new, 5) " going down
    else
      let s:line_new -= 1
      call cursor((s:line_new < 2 ? 2 : s:line_new), 5) " going up
    endif
  else
    call cursor((s:line_new < 2 ? 2 : 0), 5) " hold cursor in column
  endif
endfunction

function! s:sort(d1, d2) abort
  return a:d1["pos"] - a:d2["pos"]
endfunction

function! s:setup() abort
  augroup vim_project
    autocmd!
    let projects = sort(values(s:projects), "s:sort")
    for v in projects
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
