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

command! GasyncTagsEnable call gasynctags#Enable()
command! GasyncTagsDisable call gasynctags#Disable()

augroup GasyncTagsEnable

let g:loaded_gasynctags = 1

if g:gasynctags_autostart == 1
    call gasynctags#Enable()
endif

