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

fun CopenRun(cmd)
    copen
    silent! exe a:cmd
endf

if g:gasynctags_map_key == 1
    nmap <silent> <Leader>s :call CopenRun("cs f s ".expand('<cword>')) <CR>
    vmap <silent> <Leader>s :call CopenRun("cs f s ".getline("'<")[getpos("'<")[2]-1:getpos("'>")[2] - 1]) <CR>
    nmap <silent> <Leader>g :call CopenRun("cs f t ".expand('<cword>')) <CR>
    vmap <silent> <Leader>g :call CopenRun("cs f t ".getline("'<")[getpos("'<")[2]-1:getpos("'>")[2] - 1]) <CR>
    command! -nargs=1 S silent! cexpr[] <BAR> exe "cs f t"<f-args> <BAR> copen
endif

command! GasyncTagsEnable call gasynctags#Enable()
command! GasyncTagsDisable call gasynctags#Disable()

if g:gasynctags_autostart == 1
    au VimEnter * call gasynctags#Enable()
endif

let g:loaded_gasynctags = 1
