let g:gasynctags_autostart = get(g:, 'gasynctags_autostart', 1)

if !executable('gtags') || !executable('global')
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

if g:gasynctags_autostart == 1
    GasyncTagsEnable
endif

let g:loaded_gasynctags = 1
