move-less.vim
============

move-less is all about faster navigation by moving less around.

The idea is that you fold the space between your line and the target destination and then jump to the target position. 


To archive this there is a so called move-less-mode which you can enter by typing LEADER+m.
If you want to remap the setting you can just create a mapping which calls the function MoveLessMode.

If you are in the move-less mode you can navigate like the following:

j: Type once and your line will be displayed at the top (if possible). Every further click will fold lines below your cursor. So you can see the text under your cursor. The number of lines which are fold are defined by the scroll attribute.

k: Type once and your line will be displayed at the bottom (if possible). Every further click will fold lines below your cursor, so you can see the upper text. The number of lines which are fold are defined by the scroll attribute.

J: Type once and your line will be displayed at the top (if possible). Any further click will reduce the fold below your cursor position. So, that you are able to see text again which you already have fold (kind of an undo of j)

K: Type once and your line will be displayed at the bottom. Any further click will reduce the fold above your cursor position. So, that you are able to see text again which you already have fold (kind of an undo of k)

k: Type once and your line will be displayed at the middle. Any further click will fold the text above and below your cursor position. So, that you are able to search your target positon in both directions.

h: Type once and your line will be displayed at the middle. Any further click will reduce the fold above and below your cursor position. So, you can see the text again which you already fold. It's kind of an undo for k.

ESC: Abort move less mode and delete all foldings, you are not able to jump to Any distance place now.

Any other key: Move less mode will directly be ended, but folding will be temporary remain. From now on, you can jump over the folding to get to your target position. You can use Any vim method you like for this action. For example move-less is intended to work pretty well with easymotion.
After such an action the folding will be immediately removed. It is only intended to be used for navigation without moving.

License
-------

Copyright (c) Andreas Schnapp.  Distributed under the same terms as Vim itself.
See `:help license`.
