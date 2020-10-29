let s:dirty = 0
let s:busy = 0
fun gasynctags#update_if_need(force)
    if a:force == 1
        let s:dirty = 1
    endif

    if s:busy == 1
        return
    endif

    if s:dirty == 1
        let s:dirty = 0
        let s:busy = 1
        if has('nvim') == 1
            call jobstart("global -u --single-update=\"" . expand("%") . "\"", {"in_io": "null", "out_io": "null", "err_io": "null", "exit_cb" : "gasynctags#on_updated"})
        else
            call job_start("global -u --single-update=\"" . expand("%") . "\"", {"in_io": "null", "out_io": "null", "err_io": "null", "exit_cb" : "gasynctags#on_updated"})
        endif
    endif
endf

fun gasynctags#on_updated(channel, msg)
    let s:busy = 0
    call gasynctags#update_if_need(0)
endf

fun gasynctags#Enable()
    let l:dir = trim(system('global -p'))
    if v:shell_error != 0
        return
    endif

    silent exe 'cs add ' . l:dir . '/GTAGS'

    silent! au! GasyncTagsEnable
    augroup GasyncTagsEnable
        au!
        au BufWritePost * call gasynctags#update_if_need(1)
    augroup END
endf

fun! gasynctags#Disable()
    au! GasyncTagsEnable
endf
