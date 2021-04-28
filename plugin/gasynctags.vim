let g:gasynctags_autostart = get(g:, 'gasynctags_autostart', 1)
let g:gasynctags_map_key = get(g:, 'gasynctags_map_key', 1)

if !executable('global')
    echohl WarningMsg |
                \ echomsg 'Gasynctags unavailable: global not found under $PATH' |
                \ echohl None
    finish
endif


if exists('g:loaded_gasynctags')
      finish
endif

if g:gasynctags_map_key == 1
    nmap <silent> <Leader>s :silent! cexpr[] <BAR> exe "cs f s ".expand('<cword>')<CR> <BAR> :copen <CR>
    vmap <silent> <Leader>s :silent! <C-U> cexpr[] <BAR> exe "cs f s ".getline("'<")[getpos("'<")[2]-1:getpos("'>")[2] - 1]<CR> <BAR> :copen <CR>
    nmap <silent> <Leader>g :silent! cexpr[] <BAR> exe "cs f t ".expand('<cword>')<CR> <BAR> :copen <CR>
    vmap <silent> <Leader>g :silent! <C-U> cexpr[] <BAR> exe "cs f t ".getline("'<")[getpos("'<")[2]-1:getpos("'>")[2] - 1]<CR> <BAR> :copen <CR>
    command! -nargs=1 S silent! cexpr[] <BAR> exe "cs f t"<f-args> <BAR> copen
endif


fun s:enable()
    silent! au! GasyncTagsStarter
    augroup GasyncTagsStarter
        au FileType c,cpp call gasynctags#Enable()
    augroup END
endfun

fun s:disable()
    silent! au! GasyncTagsStarter
    call gasynctags#Disable()
endfun

command! GasyncTagsEnable call s:enable()
command! GasyncTagsDisable call s:disable()

if g:gasynctags_autostart == 1
    call s:enable()
endif

let g:loaded_gasynctags = 1
