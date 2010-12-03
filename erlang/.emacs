
(setq load-path(cons "/usr/emacs/common" load-path))
(require 'wb-line-number)
(wb-line-number-toggle)

;; This is needed for Erlang mode setup
(setq erlang-root-dir "/usr/local/lib/erlang")
(setq load-path (cons "/usr/local/lib/erlang/lib/tools-2.6.5.1/emacs" load-path))
(setq exec-path (cons "/usr/local/lib/erlang/bin" exec-path))
(require 'erlang-start)
;; This is needed for Distel setup
(let ((distel-dir "/home/erlang/elisp/distel/elisp"))
  (unless (member distel-dir load-path)
    ;; Add distel-dir to the end of load-path
    (setq load-path (append load-path (list distel-dir)))))

(require 'distel)
(distel-setup)

;; Some Erlang customizations
(add-hook 'erlang-mode-hook
	  (lambda ()
	    ;; when starting an Erlang shell in Emacs, default in the node name
	    (setq inferior-erlang-machine-options '("-sname" "emacs"))
	    ;; add Erlang functions to an imenu menu
	    (imenu-add-to-menubar "imenu")))

;; A number of the erlang-extended-mode key bindings are useful in the shell too
(defconst distel-shell-keys
  '(("\C-\M-i"   erl-complete)
    ("\M-?"      erl-complete)	
    ("\M-]"      erl-find-source-under-point)
    ("\M-,"      erl-find-source-unwind) 
    ("\M-*"      erl-find-source-unwind) 
    )
  "Additional keys to bind when in Erlang shell.")


;;(add-hook 'erlang-shell-mode-hook
;;	  (lambda ()
;;	    ;; add some Distel bindings to the Erlang shell
;;	    (dolist (spec distel-shell-keys)
;;	      (define-key erlang-shell-mode-map (car spec) (cadr spec)))))

(require 'flymake)
(defun flymake-erlang-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
		     'flymake-create-temp-inplace))
	 (local-file (file-relative-name temp-file
		(file-name-directory buffer-file-name))))
    (list "/home/erlang/elisp/ecompile.sh" (list local-file))))

(add-to-list 'flymake-allowed-file-name-masks '("\\.erl\\'" flymake-erlang-init))
(add-hook 'find-file-hooks 'flymake-find-file-hook)

;; flymake

(defun my-flymake-show-next-error()

    (interactive)

    (flymake-goto-next-error)

    (flymake-display-err-menu-for-current-line) )

(local-set-key "\C-c\C-v" 'my-flymake-show-next-error)


(defun flymake-display-err-minibuffer ()
  "¸ÄÐÐÓÐ error »ò warinig ÏÔÊ¾ÔÚ minibuffer"
  (interactive)
  (let* ((line-no (flymake-current-line-no))
         (line-err-info-list (nth 0 (flymake-find-err-info flymake-err-info line-no)))
         (count (length line-err-info-list)))
    (while (> count 0)
      (when line-err-info-list
        (let* ((file (flymake-ler-file (nth (1- count) line-err-info-list)))
               (full-file (flymake-ler-full-file (nth (1- count) line-err-info-list)))
               (text (flymake-ler-text (nth (1- count) line-err-info-list)))
               (line (flymake-ler-line (nth (1- count) line-err-info-list))))
          (message "[%s] %s" line text)))
      (setq count (1- count)))))

(defadvice flymake-goto-next-error (after display-message activate compile)
  "ÏÂÒ»¸ö´íÎó"
  (flymake-display-err-minibuffer))

(defadvice flymake-goto-prev-error (after display-message activate compile)
  "Ç°Ò»¸ö´íÎó"
  (flymake-display-err-minibuffer))

(defadvice flymake-mode (before post-command-stuff activate compile)
  "ÎªÁË½«ÎÊÌâÐÐ×Ô¶¯ÏÔÊ¾µ½ minibuffer ÖÐ£¬Ìí¼Ó post command hook "
  (set (make-local-variable 'post-command-hook)
       (add-hook 'post-command-hook 'flymake-display-err-minibuffer)))

;; post-command-hook Óë anything.el ÓÐ³åÍ»Ê±Ê¹ÓÃ
(define-key global-map (kbd "C-c d") 'flymake-display-err-minibuffer)


;;(global-set-key [f3] 'flymake-display-err-menu-for-current-line)
(global-set-key [f3] 'flymake-goto-next-error)
;;(load-library "flymake-cursor")



(require 'auto-complete-config)

(add-to-list 'load-path "/usr/emacs/common/")
(add-to-list 'ac-dictionary-directories "/usr/emacs/common/dict")

(ac-config-default)

(setq-default ac-sources '(ac-source-yasnippet  
                  ac-source-semantic  
                  ac-source-imenu  
                  ac-source-abbrev  
                  ac-source-words-in-buffer  
                  ac-source-files-in-current-dir  
                  ac-source-filename))  

(require 'ecb)
(setq tags-table-list
           '("." "/home/erlang/tool/otp_src_R13B04"))

(put 'upcase-region 'disabled nil)
