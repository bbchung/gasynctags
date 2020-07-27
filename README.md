# Vim plugin for Gnu Global(gtags) integration
## Intro
gasynctags can search and add gtags database then keep it being always updated automatically in background.

## Why
[ludovicchabant/vim-gutentags](https://github.com/ludovicchabant/vim-gutentags) provides many features on tags, but I believe
"It’s best to do one thing really really well", so gasynctags will just focus on gtags, with very lightweight code.

## Requirements

The gasynctags plugin requires the following:

* Vim version 8.1 or above or neovim
* Gnu Global binaries 6.6.3 or above

gasynctags is only tested on linux platform.

## Usage
1. Create gtags database MANUALLY on project root dir.
2. vi file(s) under project root dir and gasynctags will search gtags db and do its jobs.

## Options

### g:gasynctags_autostart
gasynctags will automatically start if set g:gasynctags_autostart to `1`,

Default: `1`
```vim
let g:gasynctags_autostart = 0
```
### g:gasynctags_map_key
Enable some useful key maps, set 0 to disable
```vim
let g:gasynctags_map_key = 0
```

## Commands

### GasynctagsEnable
### GasynctagsDisable
