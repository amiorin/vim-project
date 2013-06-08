function! s:A(cmd, file, bang) abort
  let cmds = {'E': 'edit', 'S': 'split', 'V': 'vsplit', 'T': 'tabedit', 'D': 'read'}
  let cmd = cmds[a:cmd] . a:bang
  return cmd.' '.a:file
endfunction

function! s:add_or_remove_suffix(file, suffix) abort
  let root = fnamemodify(a:file, ":r")
  let ext  = '.'.fnamemodify(a:file, ":e")
  let operation = a:suffix[0]
  let suffix    = a:suffix[1:]
  if operation ==# '+'
    return root.suffix.ext
  else
    return substitute(root, suffix.'$', '', '').ext
  endif
endfunction

function! project#utils#alternate(arguments) abort
  let object = {}
  let object['arguments'] = a:arguments
  function object.invoke(title) dict
    let params = self['arguments'][0]
    let file = substitute(bufname('%'), params['regex'], params['string'], 'g')
    if file ==# bufname('%')
      let params = self['arguments'][1]
      let file = substitute(bufname('%'), params['regex'], params['string'], 'g')
    endif
    if file ==# bufname('%')
      " no match
      return
    endif
    if has_key(params, 'suffix')
      let file = s:add_or_remove_suffix(file, params['suffix'])
    endif
    execute "command! -buffer -bang -nargs=0 A  :execute s:A('E','".file."','<bang>')"
    execute "command! -buffer -bang -nargs=0 AE :execute s:A('E','".file."','<bang>')"
    execute "command! -buffer -bang -nargs=0 AS :execute s:A('S','".file."','<bang>')"
    execute "command! -buffer -bang -nargs=0 AV :execute s:A('V','".file."','<bang>')"
    execute "command! -buffer -bang -nargs=0 AT :execute s:A('T','".file."','<bang>')"
    execute "command! -buffer -bang -nargs=0 AD :execute s:A('D','".file."','<bang>')"
    execute "command! -buffer -bang -nargs=0 AR :execute s:A('D','".file."','<bang>')"
  endfunction
  return object
endfunction

