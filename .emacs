;; tuareg-mode 読み込み
(setq load-path (cons "~/dotfiles/lib/tuareg-mode-1.45.7" load-path))
(setq auto-mode-alist (cons ’("\.ml\w?" . tuareg-mode) auto-mode-alist))
    (autoload ’tuareg-mode "tuareg" "Major mode for editing Caml code" t)
    (autoload ’camldebug "camldebug" "Run the Caml debugger" t)
    (if (and (boundp ’window-system) window-system)
        (when (string-match "XEmacs" emacs-version)
            (if (not (and (boundp ’mule-x-win-initted) mule-x-win-initted))
                (require ’sym-lock))
            (require ’font-lock)))

; OCaml 設定
(require 'package)
;; MELPA-stableを追加
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;; 初期化
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (exec-path-from-shell tuareg))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
