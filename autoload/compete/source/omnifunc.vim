"
" compete#source#omnifunc#register
"
function! compete#source#omnifunc#register() abort
  call compete#source#register({
  \   'name': 'omnifunc',
  \   'complete': function('s:complete'),
  \   'filetype': ['*'],
  \   'priority': 90,
  \ })
endfunction

"
" complete
"
function! s:complete(context, callback) abort
  if &omnifunc ==# ''
    return a:context.abort()
  endif

  try
    let l:start = call(&omnifunc, [1, ''])
    let l:base = strpart(getline('.'), l:start, col('.') - l:start)
    let l:result = call(&omnifunc, [0, l:base])
    let l:result = type(l:result) == type([]) ? l:result : get(l:result, 'words', [])
    call a:callback({
    \   'items': map(copy(l:result), function('s:normalize_item'))
    \ })
  catch /.*/
    call a:context.abort()
  endtry
endfunction

"
" normalize_items
"
function! s:normalize_item(idx, item) abort
  if type(a:item) == type('')
    return { 'word': a:item }
  endif
  return a:item
endfunction

