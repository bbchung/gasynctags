let s:job_queue = []
let s:pending = {}
let s:busy = 0

fun gasynctags#single_update(path)
    if has_key(s:pending, a:path) == 1
        call remove(s:pending, a:path)
    endif

    let s:busy = 1
    if has('nvim') == 1
        call jobstart("global -u --single-update=\"" . a:path . "\"", {"in_io": "null", "out_io": "null", "err_io": "null", "exit_cb" : {channel, msg -> gasynctags#on_updated(a:path)}})
    else
        call job_start("global -u --single-update=\"" . a:path . "\"", {"in_io": "null", "out_io": "null", "err_io": "null", "exit_cb" : {channel, msg -> gasynctags#on_updated(a:path)}})
    endif
endf

fun gasynctags#global_update()
    let s:pending = {}

    let s:busy = 1
    if has('nvim') == 1
        call jobstart("global -u", {"in_io": "null", "out_io": "null", "err_io": "null", "exit_cb" : "gasynctags#on_init"})
    else
        call job_start("global -u", {"in_io": "null", "out_io": "null", "err_io": "null", "exit_cb" : "gasynctags#on_init"})
    endif
endf

fun gasynctags#poll_job()
    if !empty(s:job_queue)
        s:job_queue[0]()
        call remove(s:job_queue, 0)
    endif
endf

fun gasynctags#update(path)
    if has_key(s:pending, a:path) == 0
        let s:pending[a:path] = 1
        if s:busy == 1
            call add(s:job_queue, {-> gasynctags#single_update(a:path)})
        else
            call gasynctags#single_update(a:path)
        endif
    endif
endf

fun gasynctags#init()
    if s:busy == 1
        call add(s:job_queue, {-> gasynctags#global_update()})
    else
        call gasynctags#global_update()
    endif
endf

fun gasynctags#on_updated(path)
    let s:busy = 0

    call gasynctags#poll_job()
endf

fun gasynctags#on_init(channel, msg)
    let s:busy = 0

    silent exe 'cs add ' . s:dir . '/GTAGS'
    call gasynctags#poll_job()
endf

fun gasynctags#Enable()
    let s:dir = trim(system('global -p'))
    if v:shell_error != 0
        return
    endif

    call gasynctags#init()

    silent! au! GasyncTagsEnable
    augroup GasyncTagsEnable
        au!
        au BufWritePost * call gasynctags#update(expand("%"))
    augroup END
endf

fun! gasynctags#Disable()
    let s:job_queue = []
    let s:pending = {}
    au! GasyncTagsEnable
endf
