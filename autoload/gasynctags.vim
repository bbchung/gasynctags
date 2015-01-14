python << endpython
import subprocess
import os.path

def start_update_tags(init=False):
    if hasattr(start_update_tags, 'proc') and start_update_tags.proc.poll() is None:
        return

    with open(os.devnull, 'w') as shutup:
        cmd = None
        if init:
            cmd = [vim.vars['gasynctags_gtags']]
        if os.path.isfile('GTAGS') and os.path.isfile('GPATH') and os.path.isfile('GRTAGS'):
            cmd = [vim.vars['gasynctags_global'], "-u"]

        if cmd is not None:
            start_update_tags.proc = subprocess.Popen(cmd, stdout = shutup, stderr = shutup)
endpython


fun! gasynctags#Enable()
    if exists("s:gasynctags_enabled")
        return
    endif

    augroup GasyncTagsEnable
        au!
        au BufWritePost * py start_update_tags()
    augroup END

    py start_update_tags(True)

    let s:gasynctags_enabled = 1
endf

fun! gasynctags#Disable()
    au! GasyncTagsEnable

    silent! unlet s:gasynctags_enabled
endf
