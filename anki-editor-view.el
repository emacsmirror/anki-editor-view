;;; anki-editor-view.el --- Open Anki notes in Emacs -*- lexical-binding: t; -*-

;; Copyright (c) 2023 Valentin Herrmann

;; Author: Valentin Herrmann <me@valentin-herrmann.de>
;; Version: 0.1.1
;; Package-Requires: ((emacs "25.1"))
;; URL: https://gitlab.com/vherrmann/anki-editor-view

;;; Commentary:

;; Open Anki notes in Emacs from Anki
;; This file is not a part of GNU Emacs.

;;; License:

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <https://www.gnu.org/licenses/>.

(require 'org)
(require 'org-protocol)

;;; Custom variables:

(defgroup anki-editor-view nil
  "Open anki notes in Emacs from Anki."
  :group 'anki-editor)

(defcustom anki-editor-view-files (list org-directory)
  "Files and directories to search for anki-editor-notes."
  :type '(repeat :tag "List of files and directories" file)
  :group 'anki-editor-view)

;;; Code:

(defun anki-editor-view--ripgrep-find-locations (search-string directories)
  "Search for all locations of SEARCH-STRING in DIRECTORIES with ripgrep.

Returns a list of alists in the form `((file . \"…\") (line . …))'"
  (let* ((directories-string (apply #'concat
                                    (cl-map 'list
                                            (lambda (dir)
                                              (format " %S" dir))
                                            directories)))
         (command (format "rg -n -e %S --no-heading %s"
                          search-string
                          directories-string))
         (result (shell-command-to-string command))
         (locations (split-string result "\n" t)))
    (cl-map 'list (lambda (it)
                    (if (string-match "\\([^:]+\\):\\([0-9]+\\):" it)
                        `((file . ,(match-string 1 it))
                          (line . ,(string-to-number (match-string 2 it))))
                      (error "Ripgrep result is malformed")))
            locations)))

(defun anki-editor-view--open-anki-note (info)
  "Open the anki note with the given id."
  (let* ((search-string (format ":ANKI_NOTE_ID: %s" (plist-get info :id)))
         (locations
          (anki-editor-view--ripgrep-find-locations search-string
                                                    anki-editor-view-files)))
    (if (null locations)
        (message "Anki note not found.")
      (when (< 1 (length locations))
        (message "Warning: Found more than one (%s) location of the Anki Note" (length locations)))
      (let* ((location (car locations))
             (file (alist-get 'file location))
             (line (alist-get 'line location)))
        (find-file file)
        (goto-char (point-min))
        (forward-line (1- line))
        (org-back-to-heading t)
        (org-fold-show-context)
        (org-fold-show-subtree)
        (recenter-top-bottom)))

    ;; See `org-protocol-protocol-alist'
    nil))

(add-to-list 'org-protocol-protocol-alist
             `("anki-editor-view" :protocol "anki-editor-view" :function ,#'anki-editor-view--open-anki-note))

(provide 'anki-editor-view)

;;; anki-editor-view.el ends here
