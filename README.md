# anki-editor-view

Do you use anki [anki-editor](https://github.com/louietan/anki-editor/) for your Anki notes? While reviewing your cards, have you ever found a silly spelling error or inaccuracy? And had to search for the note in your org files? Anki-editor-view might be something for you if you answered yes to all of these questions. It's an Anki plugin for opening Anki-editor notes in Emacs.

## Installation

Install the Anki plugin by downloading it from [the official website](https://ankiweb.net/shared/info/1301464350). Install the emacs plugin in e.g. doom emacs with use-package by adding
``` emacs-lisp
(package! anki-editor-view)
```
to your package.el and
``` emacs-lisp
(use-package! anki-editor-view
    :config
    (setq anki-editor-view-files (list org-directory)))
```
to config.el. 
You also need to install [ripgrep](https://github.com/BurntSushi/ripgrep) to use this plugin.

If you haven't setup org-protocol yet, you need to configure your system as described in [worg](https://orgmode.org/worg/org-contrib/org-protocol.html).

## Usage

The Anki plugin adds the keybinding `C-O` to the reviewer and the browser. You can also use the "More" menu in the reviewer and the "Notes" menu in the browser.

## Contributing

I will try to take a look at every pr, but I (probably) won't implement your feature requests.
