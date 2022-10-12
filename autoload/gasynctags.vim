vim9script

var enabled = 0
var job_queue = []
var pending = {}
var busy = 0

def SingleUpdate(path: string, Cb: func)
    if has_key(pending, path) == 1
        remove(pending, path)
    endif

    busy = 1
    if has('nvim') == 1
        jobstart(g:global_path .. " -u --single-update=\"" .. path .. "\"", {"in_io": "null", "out_io": "null", "err_io": "null", "exit_cb": (job, ec) => {
            Cb(path)
        }})
    else
        job_start(g:global_path .. " -u --single-update=\"" .. path .. "\"", {"in_io": "null", "out_io": "null", "err_io": "null", "exit_cb": (job, ec) => {
            Cb(path)
        }})
    endif
enddef

def GlobalUpdate(Cb: func)
    pending = {}

    busy = 1
    if has('nvim') == 1
        silent! jobstart(g:global_path .. " -u", {"in_io": "null", "out_io": "null", "err_io": "null", "exit_cb": Cb})
    else
        silent! job_start(g:global_path .. " -u", {"in_io": "null", "out_io": "null", "err_io": "null", "exit_cb": Cb})
    endif
enddef

def PullJob()
    if !empty(job_queue)
        job_queue[0]()
        remove(job_queue, 0)
    endif
enddef

def Update(path: string)
    if has_key(pending, path) == 0
        pending[path] = 1
        if busy == 1
            add(job_queue, () => {
                SingleUpdate(path, (updated_path) => {
                    OnUpdated(updated_path)
                })
            })
        else
            SingleUpdate(path, (updated_path) => {
                OnUpdated(updated_path)
            })
        endif
    endif
enddef

def Init()
    if busy == 1
        add(job_queue, () => {
            GlobalUpdate(OnInit)
        })
    else
        GlobalUpdate(OnInit)
    endif
enddef

def OnUpdated(path: string)
    busy = 0

    PullJob()
enddef

def OnInit(job: job, ec: number)
    busy = 0

    PullJob()
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
    Init()

    silent! au GasyncTagsEnable
    enabled = 1
enddef

export def Disable()
    job_queue = []
    pending = {}
    silent! au! GasyncTagsEnable
    enabled = 0
enddef

augroup GasyncTagsEnable
    au!
    au BufWritePost * Update(expand("%"))
augroup END
