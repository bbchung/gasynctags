vim9script

import autoload 'gasynctags.vim'

g:gasynctags_autostart = get(g:, 'gasynctags_autostart', 1)
g:gasynctags_map_key = get(g:, 'gasynctags_map_key', 1)
g:global_path = get(g:, 'global_path', 'global')

if !executable(g:global_path)
    echohl WarningMsg |
                \ echomsg 'Gasynctags unavailable: global not found' |
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

command! GasyncTagsEnable gasynctags.Enable()
command! GasyncTagsDisable gasynctags.Disable()

if g:gasynctags_autostart == 1
    au VimEnter * gasynctags.Enable()
endif

g:loaded_gasynctags = 1
