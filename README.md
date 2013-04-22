## About
This plugin ``lcd`` to the root of the project everytime you ``BufEnter`` a
file inside a project.

![img][0]

## Install
If you use [Vundle][1] you can install this plugin using Vim command `:BundleInstall amiorin/vim-project`.
Don't forget put a line `Bundle 'amiorin/vim-project'` in your `.vimrc`.

If you use [Pathogen][2], you just execute following:

```sh
cd ~/.vim/bundle
git https://github.com/amiorin/vim-project.git
```

If you don't use either plugin management system, copy the `plugin` directory to your `.vim` directory.

\*nix: $HOME/.vim
Windows: $HOME/vimfiles

## Configure
sample ``.vimrc``:

```vim
set rtp+=~/.vim/bundle/vim-project/
call project#rc("~/Code")

" the title for all files will be gollum
Project 'gollum'
" the title for only this file will be todo
File    'gollum/Todo.md'                       , 'todo'
```

## Interactive
From the ``command-line``.

``ProjectPath`` uses the ``cwd`` and the arguments are not quoted.
```vim
:ProjectPath .
:ProjectPath /etc etcetera
```

## Self-Promotion
Like this plugin?
* Star the repository on [GitHub](https://github.com/amiorin/vim-fenced-code-blocks)
* Follow me on
  * [Twitter](http://twitter.com/amiorin)
  * [GitHub](https://github.com/amiorin)
  * [Blog](http://albertomiorin.com)

[0]: https://pbs.twimg.com/media/BIcCUupCMAEG8Lg.png:large
[1]: https://github.com/gmarik/vundle.git
[2]: https://github.com/tpope/vim-pathogen
