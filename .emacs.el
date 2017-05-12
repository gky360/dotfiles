(add-to-list 'load-path "~/dotfiles/.elisp")
(add-to-list 'load-path "~/dotfiles/.elisp/tuareg-mode")

(require 'cl)
(defvar my/packages
  '(
    ;; packages to install
    exec-path-from-shell
    tuareg
    ))

(require 'package)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(let ((not-installed (remove-if 'package-installed-p my/packages)))
  (when not-installed
    (package-refresh-contents)
    (dolist (package my/packages)
      (package-install package))))

;; Avoid to write `package-selected-packages` in init.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;;; append-tuareg.el - Tuareg quick installation: Append this file to .emacs.
(setq auto-mode-alist (cons '("\\.ml\\w?" . tuareg-mode) auto-mode-alist))
(autoload 'tuareg-mode "tuareg" "Major mode for editing Caml code" t)
(autoload 'camldebug "camldebug" "Run the Caml debugger" t)
(if (and (boundp 'window-system) window-system)
    (when (string-match "XEmacs" emacs-version)
        (if (not (and (boundp 'mule-x-win-initted) mule-x-win-initted))
            (require 'sym-lock))
        (require 'font-lock)))
