# anki-editor-view

Anki plugin to open [anki-editor](https://github.com/louietan/anki-editor/) notes over org-protocol from anki in emacs.

## Usage

Install the Anki plugin by downloading it from [the official website](https://ankiweb.net/shared/info/1301464350). Install the emacs plugin in e.g. doom emacs with use-package by adding
``` emacs-lisp
(package! anki-editor-view
  :recipe (:type git
           :host gitlab
           :repo "vherrmann/anki-editor-view"))
```
to your package.el and
``` emacs-lisp
(use-package! anki-editor-view
    :config
    (setq anki-editor-view-files (list org-directory)))
```
to config.el. 
You also need to install [ripgrep](https://github.com/BurntSushi/ripgrep) to use this plugin.

## Contribute

I will try to take a look at every pr, but I (probably) won't implement your feature requests.
