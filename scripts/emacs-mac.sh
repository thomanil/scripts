#! /bin/bash
# file: /usr/local/bin/emacs
case "$*" in  
*-nw*) /Applications/Emacs.app/contents/MacOS/emacs $*;; 
*--no-window-system*) /Applications/Emacs.app/contents/MacOS/emacs $*;;  
*) /Applications/Emacs.app/contents/MacOS/emacs $* &;;
esac