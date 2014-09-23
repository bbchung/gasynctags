python << endpython
import subprocess
import os.path

def start_update_tags():
    if hasattr(start_update_tags, 'proc') and start_update_tags.proc.poll() is None:
        return
    
    with open(os.devnull, 'w') as shutup:
        args = [vim.vars['gasynctags_global_exe'], "-u"] if os.path.isfile('GTAGS') else [vim.vars['gasynctags_gtags_exe']]
        start_update_tags.proc = subprocess.Popen(args, stdout = shutup, stderr = shutup) 
endpython


fun! gasynctags#Enable()
    augroup GasyncTagsEnable
        au!
        au BufWritePost * py start_update_tags()
    augroup END

    py start_update_tags()
endf

fun! gasynctags#Disable()
    au! GasyncTagsEnable
endf
