python << endpython
import subprocess
import os.path
proc = None
def start_update_tags():
    global proc
    
    if proc != None and subprocess.poll(proc) != None:
        return

    with open(os.devnull, 'w') as shutup:
        if os.path.isfile('GTAGS'):
            proc = subprocess.Popen(["global", "-u"], stdout = shutup, stderr = shutup) 
        else:
            proc = subprocess.Popen(["gtags"], stdout = shutup, stderr = shutup) 
endpython

fun! s:start_update_tags()
python << endpython
start_update_tags()
endpython
endf

fun! gasynctags#Enable()
    set cscopeprg=gtags-cscope
    set cst
    set csto=1
    set nocsverb

    augroup GasyncTagsEnable
        au!
        au FileType c,cpp call s:map_keys()
        au BufWritePost *.[ch],*.[ch]pp silent! call s:start_update_tags()
        au VimEnter *.[ch],*.[ch]pp silent! call s:start_update_tags()
    augroup END
endf

fun! gasynctags#Disable()
    au! GasyncTagsEnable
    call s:unmap_keys()
endf

fun! gasynctags#AddTagAndCall(op)
    if s:check_and_add_tags() == 1
	    execute "cs f ".a:op." ".expand("<cword>")
    endif
endf

fun! s:unmap_keys()
	silent! unmap <C-\>s
	silent! unmap <C-\>g
	silent! unmap <C-\>c
	silent! unmap <C-\>t
	silent! unmap <C-\>e
	silent! unmap <C-\>f
	"silent! unmap <C-\>i
	silent! unmap <C-\>d
	silent! unmap <C-\>u
endf

fun! s:check_and_add_tags()
	if cscope_connection(1, 'GTAGS')
        return 1
    endif

	if filereadable("GTAGS")
		cs add GTAGS
        return 1
	endif

    return 0
endf

fun! s:map_keys()
	"silent! nmap <silent><C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
	silent! nmap <silent><C-\>s :call gasynctags#AddTagAndCall('s')<CR>
	silent! nmap <silent><C-\>g :call gasynctags#AddTagAndCall('g')<CR>
	silent! nmap <silent><C-\>c :call gasynctags#AddTagAndCall('c')<CR>
	silent! nmap <silent><C-\>t :call gasynctags#AddTagAndCall('t')<CR>
	silent! nmap <silent><C-\>e :call gasynctags#AddTagAndCall('e')<CR>
	silent! nmap <silent><C-\>f :call gasynctags#AddTagAndCall('f')<CR>
	"silent! nmap <silent><C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
	silent! nmap <silent><C-\>d :call gasynctags#AddTagAndCall('d')<CR>
endf
