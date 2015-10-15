if has('vim_starting')
  if &compatible
    set nocompatible
  endif
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle'))

NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'embear/vim-localvimrc'
NeoBundle 'Chiel92/vim-autoformat'
NeoBundle 'tomasr/molokai'

if filereadable(expand('~/.vimrc.neobundle'))
    source ~/.vimrc.neobundle
endif

call neobundle#end()

filetype plugin indent on

NeoBundleCheck

syntax enable

runtime! rc.d/.vimrc.*
if filereadable(expand('~/.vimrc.local'))
    source ~/.vimrc.local
endif
