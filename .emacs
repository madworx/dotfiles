;;
;; .emacs for
;;
;;   Martin Adolfsson              <mad@netilium.org>
;;   http://netilium.org/~mad/
;;
;; This .emacs is used on a number of operating systems; namely Tru64,
;; HP-UX, Linux, Solaris, MacOS X and Windows.
;;
;; Last updated: 30-May-2005
;;
;; 08-May-2003:
;;   * Added {dos|unix}2{unix|dos} functions.
;;
;; 13-May-2003:
;;   * Added code to (cleanup-code) to remove newlines at end of file.
;;   * Added fancy region decoration.
;;   * Fixed  so  that  it  doesn't  break  XEmacs that much  anymore.
;;   * Added \C-n binding to switch to next buffer.
;;
;; 03-Jun-2003:
;;   * Added 'inhibit-eol-conversion'.
;;
;; 11-Jun-2003:
;;   * Added 'completion-ignore-case' and 'c-electric-pound-behavior'.
;;
;; 13-Jul-2003:
;;   * Cleaned up conditional GNU Emacs code.
;;
;; 14-Sep-2003:
;;   * Added some stuff for MacOS X support.
;;   * Added 'fix-broken-indentation' function.
;;   * Added 'indent-whole-buffer' function.
;;
;; 17-Jan-2004:
;;   * Added (black-mode) for changing the colorization.
;;   * Fixed  remote  printing   on  Windows  platform.  (Now requires
;;     GhostScript to be installed on said platform)
;;   * Changed font sizes on windows platform.
;;   * Removed egrep references on Windows platform. :(
;;
;; 07-Feb-2004:
;;   * Fixed support for swedish keyboard input.
;;
;; 10-Feb-2004:
;;   * Fixed more portability for the grep command.
;;
;; 15-Feb-2004:
;;   * Added function (java-generate-singleton), with keybinding.
;;
;; 17-Mar-2004:
;;   * Changed search and  replace bindings to use regexp versions per
;;     default.
;;
;; 10-Jan-2005:
;;   * Fixed default colors.
;;   * Got rid of the useless  tool-bar-stuff.  When the heck did that
;;     one appear?
;;
;; 21-Mar-2005:
;;   * Moved tab-width to where it belongs.
;;   * Fixed broken indent-whole-buffer.
;;
;; 30-May-2005:
;;   * Added  binding   for  'filling'  a  marked  section    w/  text
;;     justification.
;;
;; 21-Mar-2018:
;;   * Since 2003,  I've found  that using  the default  font settings
;;     yields a better result ;-)
;;

(defun if-gnu-emacs (expr)
  (if (string-match "GNU" (emacs-version))
      (eval expr)))

(setq column-number-mode t
      line-number-mode t
      display-time-24hr-format t
      mouse-yank-at-point t
      inhibit-startup-message t
      display-time-day-and-date t
      next-line-add-newlines nil
      blink-cursor-interval 0.25
      vc-follow-symlinks t
      completion-ignore-case t
      read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t)

(delete-selection-mode t)
(display-time)

(setq-default indent-tabs-mode nil
              inhibit-eol-conversion t
              completion-ignore-case t
              tab-width 3)

(if (not (null window-system))
    (progn
      (show-paren-mode t)
      (global-font-lock-mode t)
      (setq font-lock-maximum-decoration t)
      (set-face-background 'region "lightgoldenrod2")
      (global-unset-key "\C-z")
      (global-unset-key "\C-x\C-z")))

(setq default-frame-alist `((minibuffer . t)
                            (menu-bar-lines . 0)
                            (tool-bar-lines . 0)
                            (background-mode . dark)
                            (cursor-color . "green")
                            (foreground-color . "white")
                            (background-color . "black")
                            ))

;; The menu-bar is oh so useless.
(if-gnu-emacs '(menu-bar-mode 0))

;; Hook for future expansion
(defun mad-cmode-hook ()
  (c-set-offset 'case-label c-basic-offset)
  (define-key c-mode-base-map "\C-m" 'newline-and-indent)
  (c-toggle-hungry-state 1)
  (setq c-basic-offset 3)
  (setq c-comment-continuation-stars "* ")
  (setq c-electric-pound-behavior (quote (alignleft))))
(add-hook 'c-mode-common-hook    'mad-cmode-hook)
(add-hook 'java-mode-common-hook 'mad-cmode-hook)
(add-hook 'sql-mode-common-hook 'mad-cmode-hook)


;;
;; Key (re-)definitions.
;;
(if (eq window-system 'mac)
    (define-key function-key-map [return] [13]))

(global-unset-key "\M-c")
(global-unset-key "\M-z")
(global-set-key "\C-r" 'isearch-backward-regexp)
(global-set-key "\C-s" 'isearch-forward-regexp)
(global-set-key "\M-%" 'query-replace-regexp)
(global-set-key "\M-g" 'goto-line)
(global-set-key "\M-m" 'man)

;; Switching between this and other buffer by pressing \C-n.
(global-set-key "\C-n" '(lambda () (interactive)
                          (switch-to-buffer (other-buffer))))


;;
;; Emacs 21 for Windows and OSX apparently maps HOME
;; and END to beginning-of-line and end-of-line instead
;; of beginning-of-buffer, end-of-buffer.
;;
;; Sigh.
;;
(global-set-key '[home] 'beginning-of-buffer)
(global-set-key '[end]  'end-of-buffer)


(setq auto-mode-alist
      (append
       (list
        (cons "\\.conf\\'" 'sh-mode)
        (cons "\\.jsp\\'"  'java-mode)
        (cons "\\.xsl\\'"  'sgml-mode)
        (cons "\\akefile" 'makefile-mode)
        (cons "Dockerfile" 'dockerfile-mode)
        (cons "README\\.md\\'" 'gfm-mode)
        (cons "\\.md\\'" 'markdown-mode)
        (cons "\\.markdown\\'" 'markdown-mode))
       auto-mode-alist))

(setq markdown-command "multimarkdown")


;;
;; Check if this systems 'grep' can handle
;; recursive searching and line-number printing
;; in a GNU Grep-fashion.
;;

;(if (not (eq window-system 'w32))
;    (if (< (call-process "egrep" nil nil "-n" "-r" "foobar" "/dev/null") 2)
;        (setq grep-command (cons "egrep -n -r \'\' *" 14))
;      (setq grep-command (cons "find . -type f -name \'*\' | xargs egrep -n \'\' /dev/null" 44))))


;;
;; Go upwards in the directory structure in an attempt
;; to find a TAGS file and then invoke the real find-tag.
;; (This will only be done once)
;;
(defun my-find-tags-and-findtag (&optional file depth)
  "Try looking for a TAGS file and then invoke find-tag"
  (interactive)
  (if (null file)
      (progn
        (setq file "TAGS")
        (setq depth 0)))
  (if (< depth 10)
      (if (not (file-exists-p file))
          (my-find-tags-and-findtag (concat "../" file) (1+ depth))
        (progn
          (visit-tags-table (expand-file-name file))
          (global-set-key "\M-." 'find-tag)
          (command-execute 'find-tag)))
    ;; We did not find any TAGS file.
    (progn
      (global-set-key "\M-." 'find-tag)
      (command-execute 'find-tag))))

(global-set-key "\M-." 'my-find-tags-and-findtag)
(setq tags-revert-without-query t)


;;
;; I (almost) never want to exit Emacs anyway.
;; (And I always manage to press \C-x\C-c accidentally.)
;;
(if (not (eq (lookup-key (current-global-map) "\C-x\C-c") 'my-save-buffers-kill-emacs))
    (progn
      (setq old-killemacsdef (lookup-key (current-global-map) "\C-x\C-c"))
      (global-set-key "\C-x\C-c" 'my-save-buffers-kill-emacs)))

(defun my-save-buffers-kill-emacs ()
  "Ask if we really meant to exit Emacs and exit it answer is yes."
  (interactive)
  (if (yes-or-no-p "Do you really wish to exit Emacs? ")
      (command-execute old-killemacsdef)))

;;
;; After having stared at my normal color setup for
;; about 72 hours, this can be a nice relief. %^)
;;
(defun black-mode ()
  (interactive)
  (save-excursion
    (set-face-background 'region "darkblue")
    (set-face-foreground 'default "white")
    (set-background-color "black")
    (set-cursor-color "white")))

(defun cleanup-code ()
  "Remove trailing whitespaces from code."
  (interactive)
  (save-excursion
    ;; Trim all whitespace at end of lines.
    (goto-char (point-min))
    (while (re-search-forward "[ \t]+$" nil t)
      (replace-match "" t nil))
    ;; Now trim trailing newlines at end of file.
    (goto-char (point-max))
    (skip-chars-backward "\t\n ")
    (delete-region (point) (point-max))))

(defun dos2unix ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "\r" nil t)
      (replace-match ""))))

;;
;; Fix swedish keyboard input.
;;
(set-input-mode (car (current-input-mode))
                (nth 1 (current-input-mode))
                0)

;;
;; Fix other peoples broken ideas of code indentation. B-]
;;
(defun fix-broken-indentation ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "\\([)=]\\)[ \n\r\t]*{" nil t)
      (replace-match "\\1 {"))))

(defun indent-whole-buffer ()
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))


;;
;; Set up printing on Windows platform.
;; Requires GhostScript to be installed in C:\gs\gs8.13
;;
(if (eq window-system 'w32)
    (progn
      (require 'ps-print)
      (setenv "GS_LIB" "c:\\gs\\gs8.13;c:\\gs\\fonts")
      (setq ps-lpr-command "c:/gs/gs8.13/bin/gswin32c")
      (setq ps-lpr-switches '("-q" "-dNOPAUSE" "-dBATCH" "-sDEVICE=mswinpr2"))
      (setq ps-printer-name t)))


;;
;; Make the mouse wheel work.
;; (This only works with GNU Emacs for now)
;;
(if-gnu-emacs
 '(progn
    (defun up-slightly () (interactive) (scroll-up 5))
    (defun down-slightly () (interactive) (scroll-down 5))
    (global-set-key [mouse-4] 'down-slightly)
    (global-set-key [mouse-5] 'up-slightly)))

;;
;; This will add a Java singleton to the current
;; working class.
;;
(defun java-generate-singleton ()
  (interactive)
  (save-excursion
    (setq start (re-search-backward "^\\(public\\)?? *class \\([a-zA-Z0-9]+\\)"))
    (goto-char start)

    (setq C (match-string 2))
    (re-search-forward "\\({ *$\\)")
    (replace-match (concat "\\1\nprivate static " C " _instance = null;\n\n"
                           "public static synchronized " C " getInstance() {\n"
                           "  return (_instance==null)?_instance=new " C "():_instance;\n"
                           "}" ))
    (indent-region start (point) nil)
    ))
(global-set-key "\C-X\C-\Js" 'java-generate-singleton)

;;
;; Fill marked section as paragraph, with text justification.
;;
(global-set-key "\C-X\C-\Jf"
                '(lambda (start end)
                  (interactive "r")
                  (fill-region-as-paragraph start end 0 nil)))

(defvar my-packages
  '(dockerfile-mode markdown-mode groovy-mode go-mode)
  "A list of packages to ensure are installed at launch.")


(defun packages-install ()
  (interactive)

  ;; Setup the package repositories we wish to use.
  (let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                      (not (gnutls-available-p))))
         (proto (if no-ssl "http" "https")))
    (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  )
  (package-initialize)
  (package-refresh-contents)
  (dolist (p my-packages)
    (when (not (package-installed-p p))
      (package-install p))))

(require 'package)

(add-hook 'python-mode-hook
  (lambda ()
    (setq-default tab-width 4)
    (setq python-indent-offset 4)
    (add-to-list 'write-file-functions 'delete-trailing-whitespace)
    (setq whitespace-line-column 79)
    (setq whitespace-style '(face lines-tail))
    (whitespace-mode)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (go-mode golang-mode groovy-mode markdown-mode dockerfile-mode ack-and-a-half))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
