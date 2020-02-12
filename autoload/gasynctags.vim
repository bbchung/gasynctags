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

    execute 'cs add ' . l:dir . '/GTAGS'

    silent! au! GasyncTagsEnable
    augroup GasyncTagsEnable
        au!
        au BufWritePost * call gasynctags#try_update()
    augroup END
endf

fun! gasynctags#Disable()
    au! GasyncTagsEnable
endf
