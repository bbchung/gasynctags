vim9script

var enabled = 0
var job_queue = []
var scheduled = {}
var busy = 0

def TryDoJob()
    if !busy && !empty(job_queue)
        job_queue[0]()
        remove(job_queue, 0)
    endif
enddef

def Update(path: string)
    if !has_key(scheduled, path) || scheduled[path] == 0
        scheduled[path] = 1
        add(job_queue, () => {
            scheduled[path] = 0

            busy = 1
            job_start(g:global_path .. " -u --single-update=\"" .. path .. "\"", {"in_io": "null", "out_io": "null", "err_io": "null", "exit_cb": (job, ec) => {
                busy = 0
                TryDoJob()
            }})
        })
    endif


    TryDoJob()
enddef

export def Enable()
    if enabled == 1
        return
    endif

    var dir = trim(system(g:global_path .. " -p"))
    if v:shell_error != 0
        return
    endif

    silent! exe 'cs add ' .. dir .. '/GTAGS'
    add(job_queue, () => {
        busy = 1
        silent! job_start(g:global_path .. " -u", {"in_io": "null", "out_io": "null", "err_io": "null", "exit_cb": (job, ec) => {
            busy = 0
            TryDoJob()
        }})
    })
    TryDoJob()

    silent! au GasyncTagsEnable
    enabled = 1
enddef

export def Disable()
    job_queue = []
    scheduled = {}
    silent! au! GasyncTagsEnable
    enabled = 0
enddef

augroup GasyncTagsEnable
    au!
    au BufWritePost * Update(expand("%"))
augroup END
