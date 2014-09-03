python << endpython
import subprocess
import os.path

gUpdateProc = None
def start_update_tags():
    global gUpdateProc
    
    if gUpdateProc is not None and gUpdateProc.poll() is None:
        return

    with open(os.devnull, 'w') as shutup:
        if os.path.isfile('GTAGS'):
            gUpdateProc = subprocess.Popen([vim.vars['gasynctags_global_exe'], "-u"], stdout = shutup, stderr = shutup) 
        else:
            gUpdateProc = subprocess.Popen([vim.vars['gasynctags_gtags_exe']], stdout = shutup, stderr = shutup) 
endpython


fun! s:check_exe_files()
    return executable(g:gasynctags_gtags_exe) == 1 && executable(g:gasynctags_global_exe) == 1 && executable(g:gasynctags_gtags_cscope_exe) == 1
endf

fun! gasynctags#Enable()
    augroup GasyncTagsEnable
        au!
        au BufWritePost * py start_update_tags()
    augroup END

    if s:check_exe_files() == 0    
        echohl ErrorMsg | echomsg "gasynctags: need Gnu Global" | echohl None')
        return
    endif

    set cscopeprg=gtags-cscope
    set cst
    set csto=1
    set nocsverb

    call s:map_keys()
    py start_update_tags()
endf

fun! gasynctags#Disable()
    au! GasyncTagsEnable
    call s:unmap_keys()
endf

fun! gasynctags#AddTagAndCall(op)
    if s:check_and_add_tags() == 0
        echohl WarningMsg | echomsg "gasynctags runtime error: tag is not ready" | echohl None')
        return
    endif

    execute "cs f ".a:op." ".expand("<cword>")
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
