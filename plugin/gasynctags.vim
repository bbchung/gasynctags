if !has('python')
    echohl WarningMsg |
                \ echomsg "Gasynctags unavailable: required python2 support" |
                \ echohl None
    finish
endif

let g:gasynctags_autostart = get(g:, 'gasynctags_autostart', 1)
let g:gasynctags_gtags = get(g:, 'gasynctags_gtags', 'gtags')
let g:gasynctags_global = get(g:, 'gasynctags_global', 'global')

if !executable(g:gasynctags_gtags) || !executable(g:gasynctags_global)
    echohl WarningMsg |
                \ echomsg "Gasynctags unavailable: need Gnu Global" |
                \ echohl None
    finish
endif


if exists('g:loaded_gasynctags')
      finish
endif

command! GasyncTagsEnable call gasynctags#Enable()
command! GasyncTagsDisable call gasynctags#Disable()

augroup GasyncTagsEnable

let g:loaded_gasynctags = 1

if g:gasynctags_autostart == 1
    augroup GasynctagsStart
        au!
        au FileType c,cpp,python call gasynctags#Enable()
    augroup END
endif
