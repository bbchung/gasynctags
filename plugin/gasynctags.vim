if !has('python')
    echohl WarningMsg |
                \ echomsg "Gasynctags unavailable: required python2 support" |
                \ echohl None
    finish
endif

if exists('g:loaded_gasynctags')
      finish
endif

let g:gasynctags_autostart = get(g:, 'gasynctags_autostart', 1)
let g:gasynctags_gtags_exe = get(g:, 'gasynctags_gtags_exe', 'gtags')
let g:gasynctags_global_exe = get(g:, 'gasynctags_global_exe', 'global')
let g:gasynctags_gtags_cscope_exe = get(g:, 'gasynctags_gtags_cscope_exe', 'gtags-cscope')

command! GasyncTagsEnable call gasynctags#Enable()
command! GasyncTagsDisable call gasynctags#Disable()

augroup GasyncTagsEnable

let g:loaded_gasynctags = 1

if g:gasynctags_autostart == 1
    augroup GasynctagsStart
        au!
        au VimEnter *.[ch],*.[ch]pp call gasynctags#Enable()
    augroup END
endif
