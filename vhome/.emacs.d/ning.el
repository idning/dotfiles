
(server-start)
;不显示toolbar
(tool-bar-mode 0)



; -------------------plugins ------------------------
;psvn 
(require 'psvn)
;;w3m

;; auto-install
(require 'auto-install)
;(setq url-proxy-services '(("http" . "10.99.60.201:8080")))
(setq auto-install-directory "~/.emacs.d/auto-install/")

;; auto-complete
;;; (require 'auto-complete)
(require 'init-auto-complete)

;; highlight-symbol
(require 'highlight-symbol)
(global-set-key [(control f3)] 'highlight-symbol-at-point)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-prev)
;(global-set-key [(return)] 'newline-and-indent)

;; visible-mark -ok
(require 'visible-mark)
(visible-mark-mode t)
(global-visible-mark-mode t) ;!!!!!

;; tabbar.el
(require 'tabbar)
(tabbar-mode t)
(define-key function-key-map [C-S-iso-lefttab] [C-backtab])
(global-set-key [(control tab)] 'tabbar-forward);;??????????有没有last-tab
;下面两个backword
(global-set-key [(control shift tab)] 'tabbar-backward);;??????????有没有last-tab
(global-set-key [C-S-iso-lefttab] 'tabbar-backward);;??????????有没有last-tab

;; (setq tabbar-buffer-groups-function
;;           (lambda ()
;;             (list "All"))) ;; code by Peter Barabas


;;---------- redo
(require 'redo)
(global-set-key ( kbd "C-.") 'redo)

;;------------layout-restore
 (require 'layout-restore)
;; save layout key
(global-set-key [?\C-c ?l] 'layout-save-current)
;; load layout key
(global-set-key [?\C-c ?\C-l ?\C-l] 'layout-restore)
;; cancel(delete) layout key
(global-set-key [?\C-c ?\C-l ?\C-c] 'layout-delete-current)

;(require 'swbuff)  -- 不清楚行为。。


;;-----------------使用Win下的选择习惯---------------
;;用shift+方向键进行选择
(pc-selection-mode) ;开 了cua就自动有了

;;-----------------Global Key Bindings-------------
(define-key global-map "\C-z" 'undo)
(define-key global-map "\C-d" 'kill-whole-line) ; same as 'ctrl+shift+backspace'
;(global-set-key [?\C-x ?k] 'kill-this-buffer)

(global-set-key [delete] 'delete-char)
(global-set-key [A-delete] 'kill-word)
(global-set-key [M-delete] 'kill-word)

;; Comment/uncomment reqion similar to Eclipse: C-/ and C-? (control shift /)
(global-set-key [(control /)] 'comment-region)
(global-set-key [(control \?)] 'uncomment-region)

(global-set-key [C-home] "\M-<")
(global-set-key [C-end] "\M->")
(global-set-key (kbd "M-o") 'other-window)
;(global-set-key [C-tab] 'other-window) ;;haha这个好

;(global-set-key (kbd "<escape>") 'keyboard-escape-quit) ; 原来是Esc Esc Esc，或者C-g


(show-paren-mode 1)  ; 高亮显示匹配的括号。

;可以使用shift+up选择一行，然后ctrl-c ctrl-v,可以直接拷贝到x-clipboard
(cua-mode t)


;; Treat 'y' or <CR> as yes, 'n' as no.
(fset 'yes-or-no-p 'y-or-n-p)
OA(define-key query-replace-map [return] 'act)
(define-key query-replace-map [?\C-m] 'act)

 
;;-----------------high ligth current line
;(global-hl-line-mode 1)


;; Show line-number in the mode line
(line-number-mode 1)
;; Show column-number in the mode line
(column-number-mode 1)

; shell 中的颜色
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)


; CEDET
(load-file "/usr/share/emacs/site-lisp/cedet-common/cedet.el") ;使用apt安装的
(load-file "/usr/share/emacs/site-lisp/ecb/ecb.el")


(require 'cedet)
;(require 'semantic-ia)
;(require 'ecb)

;; Enable EDE (Project Management) features
;(global-ede-mode 1)
 
;(semantic-load-enable-excessive-code-helpers)
;(semantic-load-enable-semantic-debugging-helpers)
 
;; Enable SRecode (Template management) minor-mode.
;(global-srecode-minor-mode 1)
;(semantic-load-enable-code-helpers)


; clipboard
(setq x-select-enable-clipboard t)




;; 当使用 M-x COMMAND 后，过 1 秒钟显示该 COMMAND 绑定的键。
(setq suggest-key-bindings 1) ;;默认？

;;;;;;;; 使用空格缩进 ;;;;;;;;
;; indent-tabs-mode  t 使用TAB作格式化字符  nil 使用空格作格式化字符
(setq indent-tabs-mode nil)
(setq tab-always-indent nil)
(setq tab-width 4)



;;关闭“开机画面”
;(setq inhibit-startup-message t)

;;用一个很大的 kill ring. 这样防止不小心删掉重要的东西
(setq kill-ring-max 200)

;防止页面滚动时跳动， scroll-margin 3 可以在靠近屏幕边沿3行时就开始滚动，
;可以很好的看到上下文。
(setq scroll-margin 3)
;每次滚动一行
(setq scroll-conservatively 1)

;;括号匹配时显示另外一边的括号，而不是烦人的跳到另一个括号。
(show-paren-mode t)
(setq show-paren-style 'parentheses)

;;设置有用的个人信息.
(setq user-full-name "ning")
(setq user-mail-address "idning@gmail.com")

;;所有的备份文件都放置在~/backups目录下
(setq backup-directory-alist (quote (("." . "~/.backups"))))
(setq version-control t)
(setq kept-old-versions 2)
(setq kept-new-versions 5)
(setq delete-old-versions t)
(setq backup-directory-alist '(("." . "~/.backups")))
(setq backup-by-copying t)

;不换行
(toggle-truncate-lines 1)

(provide 'ning)

(setq scroll-bar-mode-explicit t)
(set-scroll-bar-mode `right)

;; for test
;(setq disable-point-adjustment t)
;(setq global-disable-point-adjustment t)



(global-set-key (kbd "<f11>") 'compile)


;(define-key c-mode-base-map [(return)] 'newline-and-indent)
;

;; turn on mouse in console mode
;(mouse-wheel-mode  t)
(xterm-mouse-mode t)

