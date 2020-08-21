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
    nmap <silent> <Leader>s :silent! exe "cs f s ".expand('<cword>')<CR> <BAR> :copen <CR>
    vmap <silent> <Leader>s :silent! <C-U> exe "cs f s ".getline("'<")[getpos("'<")[2]-1:getpos("'>")[2] - 1]<CR> <BAR> :copen <CR>
    nmap <silent> <Leader>g :silent! exe "cs f t ".expand('<cword>')<CR> <BAR> :copen <CR>
    vmap <silent> <Leader>g :silent! <C-U> exe "cs f t ".getline("'<")[getpos("'<")[2]-1:getpos("'>")[2] - 1]<CR> <BAR> :copen <CR>
    command! -nargs=1 S silent! exe "cs f t"<f-args> <BAR> copen
endif

command! GasyncTagsEnable call gasynctags#Enable()
command! GasyncTagsDisable call gasynctags#Disable()

if g:gasynctags_autostart == 1
    GasyncTagsEnable
endif

let g:loaded_gasynctags = 1
