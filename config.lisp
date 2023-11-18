
(in-package #:nyxt-user)

;; Abrimos un servidor de swank para poder conectarnos desde emacs con slime
(start-swank)


;; Inicializamos quicklisp y añadimos ultralisp
(load "~/quicklisp/setup.lisp")
(when (not (ql-dist:find-dist "ultralisp"))
  (ql-dist:install-dist "http://dist.ultralisp.org/" :prompt nil))


;; Mis keybindings globales
(defvar global-map (make-keymap "global-map"))

(define-configuration input-buffer
  ((override-map global-map)))

(defun define-global-key (kbd fn)
  (define-key global-map kbd fn))

(define-key global-map
  "M-x" 'execute-command
  "C-space" 'nothing
  "C-s" 'nyxt/mode/search-buffer:search-buffer)


;; Scroll
(defparameter *scroll-slow-distance* 40)
(defparameter *scroll-fast-distance* 100)

(define-command scroll-slow-up ()
  (nyxt/mode/document:scroll-up :scroll-distance *scroll-slow-distance*))

(define-command scroll-fast-up ()
  (nyxt/mode/document:scroll-up :scroll-distance *scroll-fast-distance*))

(define-command scroll-slow-down ()
  (nyxt/mode/document:scroll-down :scroll-distance *scroll-slow-distance*))

(define-command scroll-fast-down ()
  (nyxt/mode/document:scroll-down :scroll-distance *scroll-fast-distance*))

(define-key global-map
  "M-up" 'scroll-slow-up
  "M-down" 'scroll-slow-down
  "M-s-up" 'scroll-fast-up
  "M-s-down" 'scroll-fast-down)


;; Better follow hint
(define-command better-follow-hint-new-buffer-focus ()
  (if (current-prompt-buffer)
      (nyxt/mode/prompt-buffer:quit-prompt-buffer)
      (nyxt/mode/hint:follow-hint-new-buffer-focus)))

(define-global-key "tab" 'better-follow-hint-new-buffer-focus)


;; Nyxt a pantalla maximizada por defecto
(defun maximize-window (window)
  (ffi-window-maximize window))

(define-configuration browser
  ((window-make-hook (serapeum:add-hook %slot-value% 'maximize-window))))


;; Search engines
(defvar *my-search-engines*
  (list
   ;; '("brave" "https://search.brave.com/search?q=~a&source=desktop" "https://search.brave.com")
   '("google" "https://google.com/search?q=~a" "https://google.com")))

(define-configuration context-buffer
  ((search-engines (append %slot-default% (mapcar (lambda (engine)
                                                    (apply 'make-search-engine engine))
                                                  (reverse *my-search-engines*))))))


;; Bookmarks
(define-global-key "C-b b" 'nyxt/mode/bookmark:set-url-from-bookmark)
(define-global-key "C-b M" 'nyxt/mode/bookmark:bookmark-current-url)
(define-global-key "C-b R" 'nyxt/mode/bookmark:delete-bookmark)
