vim9script

var enabled = 0
var job_queue: list<func>
var dirty: dict<bool>

def RunNextJob()
    if !job_queue->empty()
        job_queue[0]()
        job_queue->remove(0)
    endif
enddef

def Update(path: string)
    if !dirty->has_key(path) || !dirty[path]
        dirty[path] = true
        job_queue->add(() => {
            dirty[path] = false
            job_start(g:global_path .. " -u --single-update=\"" .. path .. "\"", {"in_io": "null", "out_io": "null", "err_io": "null", "exit_cb": (job, ec) => {
                RunNextJob()
            }})
        })
    endif

    if job_queue->len() == 1
        RunNextJob()
    endif
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
    job_queue->add(() => {
        job_start(g:global_path .. " -u", {"in_io": "null", "out_io": "null", "err_io": "null", "exit_cb": (job, ec) => {
            RunNextJob()
        }})
    })
    if job_queue->len() == 1
        RunNextJob()
    endif

    silent! au GasyncTagsEnable
    enabled = 1
enddef

export def Disable()
    job_queue = []
    dirty = {}
    silent! au! GasyncTagsEnable
    enabled = 0
enddef

augroup GasyncTagsEnable
    au!
    au BufWritePost * Update(expand("%"))
augroup END
