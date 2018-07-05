# move-less.vim

move-less is all about faster navigation by moving less around.

The idea is that you fold the space between your line and the target destination and then jump to the target position. Just similar to some kind of warp drive ;) 

To archive this there is a so called move-less-mode which you can enter by typing `<LEADER>m`.




Here you can see a little demo:
![move-less demonstration](https://raw.githubusercontent.com/anschnapp/hostGifsForReadmeOtherProjects/master/move-less-demo.gif)

First the user look up, then below and finally in both directions.
At the end he jumps to the target position by using plain `<number>k`

ou can now also use it to generate a temporary upper and or bottom folding. So, you can place to distance section from the upper and the bottom together. (see meaning of 'p' while in move less mode)

This can be very handy if you have to make multiple replacements or movings from two distance places. 

If you want to remap the setting you can just create a mapping which calls the function MoveLessMode.
For instance if you want to map it to `'` then you can just add the following mapping to your vimrc:

`noremap ' :call MoveLessMode()<cr>`

If you are in the move-less mode you can navigate like the following:

`j`: Type once and your line will be displayed at the top (if possible). Every further click will fold lines below your cursor. So you can see the text under your cursor. The number of lines which are fold are defined by the scroll attribute.

`k`: Type once and your line will be displayed at the bottom (if possible). Every further click will fold lines below your cursor, so you can see the upper text. The number of lines which are fold are defined by the scroll attribute.

`J`: Type once and your line will be displayed at the top (if possible). Any further click will reduce the fold below your cursor position. So, that you are able to see text again which you already have fold (kind of an undo of j)

`K`: Type once and your line will be displayed at the bottom. Any further click will reduce the fold above your cursor position. So, that you are able to see text again which you already have fold (kind of an undo of k)

`l`, or `H`: Type once and your line will be displayed at the middle. Any further click will fold the text above and below your cursor position. So, that you are able to search your target positon in both directions.

`h` or `L`: Type once and your line will be displayed at the middle. Any further click will reduce the fold above and below your cursor position. So, you can see the text again which you already fold. It's kind of an undo for `l`.

`<ESC>`: Abort move less mode and delete all foldings, you are not able to jump to Any distance place now.

`p`: Stop the move less mode but let the folding remain (p)ermanently. In fact it's just more permenant then the normal behaviour it's also temporary until you use the mode less mode next time.
If you just want to unfold later you can go to move less mode and end it directly with <ESC>. This new feature permanent feature should be handy if you want to edit two places in the file which has a big distance.

`<Any other key>`: Move less mode will directly be ended, but folding will be temporary remain. From now on, you can jump or walk over the folding to get to your target position. You can use any vim method you like for this action. For example move-less is intended to work pretty well with easymotion for archiving super fast navigation.

As long as no jump or walk over the folding was taken the fold remains, if the move-less mode is activated again in such a situation it will just continue the last mode (by still using the actual folding). 
This behavior could also be used for going into the move less mode again and make a clean abort of the mode by typing `<ESC>`.


After such an action the folding will be immediately removed. It is only intended to be used for navigation without moving.

## Installation

### Use [Vundle](https://github.com/gmarik/Vundle.vim)

Add `Plugin 'anschnapp/move-less'` to your `~/.vimrc` and run `PluginInstall`.

### Use [Pathogen](https://github.com/tpope/vim-pathogen)
```
git clone https://github.com/anschnapp/move-less ~/.vim/bundle/move-less
```

## Contribution
I welcome every kind of contribution like sending issue's, feature requests or pull requests.

## License
Copyright (c) Andreas Schnapp.  Distributed under the same terms as Vim itself.
See `:help license`.
