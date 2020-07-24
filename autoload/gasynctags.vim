let g:gasync_add_cscope  = get(g:, 'gasync_add_cscope', 1)
let g:gasync_map_key  = get(g:, 'gasync_map_key', 1)

fun gasynctags#try_update()
    if exists("s:job") && job_status(s:job) == "run"
        return
    endif

    let l:cmd = "global -u --single-update=\"" . expand("%") . "\""
    let job = job_start(l:cmd, {"in_io": "null", "out_io": "null", "err_io": "null"})
endf

fun gasynctags#Enable()
    let l:dir = trim(system('global -p'))
    if v:shell_error != 0
        return
    endif

    if g:gasync_add_cscope == 1
        execute 'cs add ' . l:dir . '/GTAGS'
    endif


    if g:gasync_map_key == 1
        nmap <silent> <Leader>s :silent! exe "cs f s ".expand('<cword>')<CR> | copen
        vmap <silent> <Leader>s :silent! <C-U> exe "cs f s ".getline("'<")[getpos("'<")[2]-1:getpos("'>")[2] - 1]<CR> | copen
        nmap <silent> <Leader>g :silent! exe "cs f t ".expand('<cword>')<CR> | copen
        vmap <silent> <Leader>g :silent! <C-U> exe "cs f t ".getline("'<")[getpos("'<")[2]-1:getpos("'>")[2] - 1]<CR> | copen
        command! -nargs=1 S silent! exe "cs f t "<f-args> | copen
    endif

    silent! au! GasyncTagsEnable
    augroup GasyncTagsEnable
        au!
        au BufWritePost * call gasynctags#try_update()
    augroup END
endf

fun! gasynctags#Disable()
    au! GasyncTagsEnable
endf
