;; Emacs mode in salesforce

(setq forcePath "~/Downloads/force")

(defun run-shell-command (command)
  "runs a shell command and returns the string
output"
  (shell-command-to-string (mapconcat 'identity command " "))
  )

(defun run-shell-command-buffer (command)
  "runs the shell command and then prints the output
or error to *Salesforce* buffer"
  (with-output-to-temp-buffer "*Salesforce*"
    (shell-command (mapconcat 'identity command " ") "*Salesforce*"
                   "*Salesforce*")

    (pop-to-buffer "*Salesforce*")
    )
  )

(defun run-sf-command (command)
  "appends force cli path to the given list
of args"
  (run-shell-command (append (list forcePath) command))
  )

(defun run-sf-command-buffer (command)
  "appends force cli path to the given list
of args and then prints the output to the
buffer"
  (run-shell-command-buffer (append
                             (list forcePath)
                             command))
  )


(defun sf-command-message (command)
  "runs an sf command and prints it on the
minibuffer"
  (message (run-sf-command command)))

(defun sf-active ()
  "prints the active sf user on minibuffer"
  (interactive)
  (sf-command-message '("active"))
  )


(defun sf-login ()
  "login to sf"
  (interactive)
  (sf-command-message '("login"))
  )



(defun sf-run-file ()
  "runs the current file as an apex code"
  (interactive)
  (run-sf-command-buffer (list "apex" (buffer-file-name)))
  )


(defun sf-object-meta ()
  "gets metadata for salesforce object"
  (interactive)
  (run-shell-command-buffer (list
                         "python"
                         "./object-data.py"
                         (grizzl-completing-read "Object: " (grizzl-make-index (get-sf-objects)))
                         )
                        )
  )


(defun get-sf-objects ()
  "gets all salesforce objects"
  (split-string (run-sf-command (list "describe"
                                      "-t"
                                      "sobject")) "\n"))

(global-set-key (kbd "C-c s r") 'sf-run-file)
(global-set-key (kbd "C-c s m") 'sf-object-meta)
(global-set-key (kbd "C-c s l") 'sf-login)
(global-set-key (kbd "C-c s a") 'sf-active)

(provide 'sf-mode)
