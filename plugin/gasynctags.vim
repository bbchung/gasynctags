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
    nmap <silent> <Leader>s :<C-R>=printf("cs f s %s", expand("<cword>"))<CR><CR> :copen 10<CR>
    vmap <silent> <Leader>s :<C-U><C-R>=printf("cs f s %s", getline("'<")[getpos("'<")[2]-1:getpos("'>")[2] - 1])<CR><CR> :copen 10<CR>
    nmap <silent> <Leader>g :<C-R>=printf("cs f t %s", expand('<cword>'))<CR><CR> :copen 10<CR>
    vmap <silent> <Leader>g :<C-U><C-R>=printf("cs f t %s", getline("'<")[getpos("'<")[2]-1:getpos("'>")[2] - 1])<CR><CR> :copen 10<CR>
    command! -nargs=1 S silent! cexpr[] <BAR> exe "cs f t"<f-args> <BAR> copen 10
endif

command! GasyncTagsEnable call gasynctags#Enable()
command! GasyncTagsDisable call gasynctags#Disable()

if g:gasynctags_autostart == 1
    au VimEnter * call gasynctags#Enable()
endif

let g:loaded_gasynctags = 1
