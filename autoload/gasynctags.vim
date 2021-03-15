let s:pending = []
let s:busy = 0

fun gasynctags#update(path)
    if s:busy == 1
        if index(s:pending, a:path) == -1
            call add(s:pending, a:path)
        endif
        return
    else
        if has('nvim') == 1
            call jobstart("global -u --single-update=\"" . a:path . "\"", {"in_io": "null", "out_io": "null", "err_io": "null", "exit_cb" : "gasynctags#on_updated"})
        else
            call job_start("global -u --single-update=\"" . a:path . "\"", {"in_io": "null", "out_io": "null", "err_io": "null", "exit_cb" : "gasynctags#on_updated"})
        endif
    endif
endf

fun gasynctags#on_updated(channel, msg)
    let s:busy = 0
    if !empty(s:pending)
        call gasynctags#update(s:pending[0])
        call remove(s:pending, 0)
    endif
endf

fun gasynctags#on_init(channel, msg)
    silent exe 'cs add ' . s:dir . '/GTAGS'
    call gasynctags#on_updated(a:channel, a:msg)
endf

fun gasynctags#Enable()
    let s:dir = trim(system('global -p'))
    if v:shell_error != 0
        return
    endif

    let s:busy = 1
    if has('nvim') == 1
        call jobstart("global -u", {"in_io": "null", "out_io": "null", "err_io": "null", "exit_cb" : "gasynctags#on_init"})
    else
        call job_start("global -u", {"in_io": "null", "out_io": "null", "err_io": "null", "exit_cb" : "gasynctags#on_init"})
    endif

    silent! au! GasyncTagsEnable
    augroup GasyncTagsEnable
        au!
        au BufWritePost * call gasynctags#update(expand("%"))
    augroup END
endf

fun! gasynctags#Disable()
    au! GasyncTagsEnable
endf
