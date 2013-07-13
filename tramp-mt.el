(defvar tramp-methods
  `(("rcp"   (tramp-login-program        "rsh")
             (tramp-login-args           (("%h") ("-l" "%u")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         "rcp")
	     (tramp-copy-args            (("-p" "%k") ("-r")))
	     (tramp-copy-keep-date       t)
	     (tramp-copy-recursive       t)
	     (tramp-password-end-of-line nil))
    ("scp"   (tramp-login-program        "ssh")
             (tramp-login-args           (("%h") ("-l" "%u") ("-p" "%p") ("-q")
					  ("-e" "none")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         "scp")
	     (tramp-copy-args            (("-P" "%p") ("-p" "%k")
					  ("-q") ("-r")))
	     (tramp-copy-keep-date       t)
	     (tramp-copy-recursive       t)
	     (tramp-password-end-of-line nil)
	     (tramp-gw-args              (("-o"
					   "GlobalKnownHostsFile=/dev/null")
					  ("-o" "UserKnownHostsFile=/dev/null")
					  ("-o" "StrictHostKeyChecking=no")))
	     (tramp-default-port         22))
    ("scp1"  (tramp-login-program        "ssh")
             (tramp-login-args           (("%h") ("-l" "%u") ("-p" "%p") ("-q")
					  ("-1" "-e" "none")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         "scp")
	     (tramp-copy-args            (("-1") ("-P" "%p") ("-p" "%k")
					  ("-q") ("-r")))
	     (tramp-copy-keep-date       t)
	     (tramp-copy-recursive       t)
	     (tramp-password-end-of-line nil)
	     (tramp-gw-args              (("-o"
					   "GlobalKnownHostsFile=/dev/null")
					  ("-o" "UserKnownHostsFile=/dev/null")
					  ("-o" "StrictHostKeyChecking=no")))
	     (tramp-default-port         22))
    ("scp2"  (tramp-login-program        "ssh")
             (tramp-login-args           (("%h") ("-l" "%u") ("-p" "%p") ("-q")
					  ("-2" "-e" "none")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         "scp")
	     (tramp-copy-args            (("-2") ("-P" "%p") ("-p" "%k")
					  ("-q") ("-r")))
	     (tramp-copy-keep-date       t)
	     (tramp-copy-recursive       t)
	     (tramp-password-end-of-line nil)
	     (tramp-gw-args              (("-o"
					   "GlobalKnownHostsFile=/dev/null")
					  ("-o" "UserKnownHostsFile=/dev/null")
					  ("-o" "StrictHostKeyChecking=no")))
	     (tramp-default-port         22))
    ("scp1_old"
             (tramp-login-program        "ssh1")
	     (tramp-login-args           (("%h") ("-l" "%u") ("-p" "%p")
					  ("-e" "none")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         "scp1")
	     (tramp-copy-args            (("-p" "%k") ("-r")))
	     (tramp-copy-keep-date       t)
	     (tramp-copy-recursive       t)
	     (tramp-password-end-of-line nil))
    ("scp2_old"
             (tramp-login-program        "ssh2")
	     (tramp-login-args           (("%h") ("-l" "%u") ("-p" "%p")
					  ("-e" "none")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         "scp2")
	     (tramp-copy-args            (("-p" "%k") ("-r")))
	     (tramp-copy-keep-date       t)
	     (tramp-copy-recursive       t)
	     (tramp-password-end-of-line nil))
    ("sftp"  (tramp-login-program        "ssh")
             (tramp-login-args           (("%h") ("-l" "%u") ("-p" "%p")
					  ("-e" "none")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         "sftp")
	     (tramp-copy-args            nil)
	     (tramp-copy-keep-date       nil)
	     (tramp-password-end-of-line nil))
    ("rsync" (tramp-login-program        "ssh")
             (tramp-login-args           (("%h") ("-l" "%u") ("-p" "%p")
					  ("-e" "none")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         "rsync")
	     (tramp-copy-args            (("-e" "ssh") ("-t" "%k") ("-r")))
	     (tramp-copy-keep-date       t)
	     (tramp-copy-keep-tmpfile    t)
	     (tramp-copy-recursive       t)
	     (tramp-password-end-of-line nil))
    ("rsyncc"
             (tramp-login-program        "ssh")
             (tramp-login-args           (("%h") ("-l" "%u") ("-p" "%p")
					  ("-o" "ControlPath=%t.%%r@%%h:%%p")
					  ("-o" "ControlMaster=yes")
					  ("-e" "none")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         "rsync")
	     (tramp-copy-args            (("-t" "%k") ("-r")))
	     (tramp-copy-env             (("RSYNC_RSH")
					  (,(concat
					     "ssh"
					     " -o ControlPath=%t.%%r@%%h:%%p"
					     " -o ControlMaster=auto"))))
	     (tramp-copy-keep-date       t)
	     (tramp-copy-keep-tmpfile    t)
	     (tramp-copy-recursive       t)
	     (tramp-password-end-of-line nil))
    ("remcp" (tramp-login-program        "remsh")
             (tramp-login-args           (("%h") ("-l" "%u")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         "rcp")
	     (tramp-copy-args            (("-p" "%k")))
	     (tramp-copy-keep-date       t)
	     (tramp-password-end-of-line nil))
    ("rsh"   (tramp-login-program        "rsh")
             (tramp-login-args           (("%h") ("-l" "%u")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         nil)
	     (tramp-copy-args            nil)
	     (tramp-copy-keep-date       nil)
	     (tramp-password-end-of-line nil))
    ("ssh"   (tramp-login-program        "ssh")
             (tramp-login-args           (("%h") ("-l" "%u") ("-p" "%p") ("-q")
					  ("-e" "none")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         nil)
	     (tramp-copy-args            nil)
	     (tramp-copy-keep-date       nil)
	     (tramp-password-end-of-line nil)
	     (tramp-gw-args              (("-o"
					   "GlobalKnownHostsFile=/dev/null")
					  ("-o" "UserKnownHostsFile=/dev/null")
					  ("-o" "StrictHostKeyChecking=no")))
	     (tramp-default-port         22))
    ("ssh1"  (tramp-login-program        "ssh")
             (tramp-login-args           (("%h") ("-l" "%u") ("-p" "%p") ("-q")
					  ("-1" "-e" "none")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         nil)
	     (tramp-copy-args            nil)
	     (tramp-copy-keep-date       nil)
	     (tramp-password-end-of-line nil)
	     (tramp-gw-args              (("-o"
					   "GlobalKnownHostsFile=/dev/null")
					  ("-o" "UserKnownHostsFile=/dev/null")
					  ("-o" "StrictHostKeyChecking=no")))
	     (tramp-default-port         22))
    ("ssh2"  (tramp-login-program        "ssh")
             (tramp-login-args           (("%h") ("-l" "%u") ("-p" "%p") ("-q")
					  ("-2" "-e" "none")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         nil)
	     (tramp-copy-args            nil)
	     (tramp-copy-keep-date       nil)
	     (tramp-password-end-of-line nil)
	     (tramp-gw-args              (("-o"
					   "GlobalKnownHostsFile=/dev/null")
					  ("-o" "UserKnownHostsFile=/dev/null")
					  ("-o" "StrictHostKeyChecking=no")))
	     (tramp-default-port         22))
    ("ssh1_old"
             (tramp-login-program        "ssh1")
	     (tramp-login-args           (("%h") ("-l" "%u") ("-p" "%p")
					  ("-e" "none")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         nil)
	     (tramp-copy-args            nil)
	     (tramp-copy-keep-date       nil)
	     (tramp-password-end-of-line nil))
    ("ssh2_old"
             (tramp-login-program        "ssh2")
	     (tramp-login-args           (("%h") ("-l" "%u") ("-p" "%p")
					  ("-e" "none")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         nil)
	     (tramp-copy-args            nil)
	     (tramp-copy-keep-date       nil)
	     (tramp-password-end-of-line nil))
    ("remsh" (tramp-login-program        "remsh")
             (tramp-login-args           (("%h") ("-l" "%u")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         nil)
	     (tramp-copy-args            nil)
	     (tramp-copy-keep-date       nil)
	     (tramp-password-end-of-line nil))
    ("telnet"
             (tramp-login-program        "telnet")
	     (tramp-login-args           (("%h") ("%p")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         nil)
	     (tramp-copy-args            nil)
	     (tramp-copy-keep-date       nil)
	     (tramp-password-end-of-line nil)
	     (tramp-default-port         23))
    ("su"    (tramp-login-program        "su")
             (tramp-login-args           (("-") ("%u")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         nil)
	     (tramp-copy-args            nil)
	     (tramp-copy-keep-date       nil)
	     (tramp-password-end-of-line nil))
    ("sudo"  (tramp-login-program        "sudo")
             (tramp-login-args           (("-u" "%u")
					  ("-s") ("-H") ("-p" "Password:")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         nil)
	     (tramp-copy-args            nil)
	     (tramp-copy-keep-date       nil)
	     (tramp-password-end-of-line nil))
    ("scpc"  (tramp-login-program        "ssh")
             (tramp-login-args           (("%h") ("-l" "%u") ("-p" "%p") ("-q")
					  ("-o" "ControlPath=%t.%%r@%%h:%%p")
					  ("-o" "ControlMaster=yes")
					  ("-e" "none")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         "scp")
	     (tramp-copy-args            (("-P" "%p") ("-p" "%k") ("-q")
					  ("-o" "ControlPath=%t.%%r@%%h:%%p")
					  ("-o" "ControlMaster=auto")))
	     (tramp-copy-keep-date       t)
	     (tramp-password-end-of-line nil)
	     (tramp-gw-args              (("-o"
					   "GlobalKnownHostsFile=/dev/null")
					  ("-o" "UserKnownHostsFile=/dev/null")
					  ("-o" "StrictHostKeyChecking=no")))
	     (tramp-default-port         22))
    ("scpx"  (tramp-login-program        "ssh")
             (tramp-login-args           (("%h") ("-l" "%u") ("-p" "%p") ("-q")
					  ("-e" "none" "-t" "-t" "/bin/bash")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         "scp")
	     (tramp-copy-args            (("-p" "%k")))
	     (tramp-copy-keep-date       t)
	     (tramp-password-end-of-line nil)
	     (tramp-gw-args              (("-o"
					   "GlobalKnownHostsFile=/dev/null")
					  ("-o" "UserKnownHostsFile=/dev/null")
					  ("-o" "StrictHostKeyChecking=no")))
	     (tramp-default-port         22))
    ("sshx"  (tramp-login-program        "ssh")
             (tramp-login-args           (("%h") ("-l" "%u") ("-p" "%p") ("-q")
					  ("-e" "none" "-t" "-t" "/bin/bash")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         nil)
	     (tramp-copy-args            nil)
	     (tramp-copy-keep-date       nil)
	     (tramp-password-end-of-line nil)
	     (tramp-gw-args              (("-o"
					   "GlobalKnownHostsFile=/dev/null")
					  ("-o" "UserKnownHostsFile=/dev/null")
					  ("-o" "StrictHostKeyChecking=no")))
	     (tramp-default-port         22))
    ("krlogin"
	     (tramp-login-program        "krlogin")
	     (tramp-login-args           (("%h") ("-l" "%u") ("-x")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         nil)
	     (tramp-copy-args            nil)
	     (tramp-copy-keep-date       nil)
	     (tramp-password-end-of-line nil))
    ("plink" (tramp-login-program        "plink")
	     (tramp-login-args           (("%h") ("-l" "%u") ("-P" "%p")
					  ("-ssh")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         nil)
	     (tramp-copy-args            nil)
	     (tramp-copy-keep-date       nil)
	     (tramp-password-end-of-line "xy") ;see docstring for "xy"
	     (tramp-default-port         22))
    ("plink1"
	     (tramp-login-program        "plink")
	     (tramp-login-args           (("%h") ("-l" "%u") ("-P" "%p")
					  ("-1" "-ssh")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         nil)
	     (tramp-copy-args            nil)
	     (tramp-copy-keep-date       nil)
	     (tramp-password-end-of-line "xy") ;see docstring for "xy"
	     (tramp-default-port         22))
    ("plinkx"
             (tramp-login-program        "plink")
	     ;; ("%h") must be a single element, see
	     ;; `tramp-compute-multi-hops'.
	     (tramp-login-args           (("-load") ("%h") ("-t")
					  (,(format
					     "env 'TERM=%s' 'PROMPT_COMMAND=' 'PS1=%s'"
					     tramp-terminal-type
					     tramp-initial-end-of-output))
					  ("/bin/bash")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         nil)
	     (tramp-copy-args            nil)
	     (tramp-copy-keep-date       nil)
	     (tramp-password-end-of-line nil))
    ("pscp"  (tramp-login-program        "plink")
	     (tramp-login-args           (("%h") ("-l" "%u") ("-P" "%p")
					  ("-ssh")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         "pscp")
	     (tramp-copy-args            (("-P" "%p") ("-scp") ("-p" "%k")))
	     (tramp-copy-keep-date       t)
	     (tramp-password-end-of-line "xy") ;see docstring for "xy"
	     (tramp-default-port         22))
    ("psftp" (tramp-login-program        "plink")
	     (tramp-login-args           (("%h") ("-l" "%u") ("-P" "%p")
					  ("-ssh")))
	     (tramp-remote-sh            "/bin/bash")
	     (tramp-copy-program         "pscp")
	     (tramp-copy-args            (("-P" "%p") ("-sftp") ("-p" "%k")))
	     (tramp-copy-keep-date       t)
	     (tramp-password-end-of-line "xy")) ;see docstring for "xy"
    ("fcp"   (tramp-login-program        "fsh")
             (tramp-login-args           (("%h") ("-l" "%u") ("sh" "-i")))
	     (tramp-remote-sh            "/bin/bash -i")
	     (tramp-copy-program         "fcp")
	     (tramp-copy-args            (("-p" "%k")))
	     (tramp-copy-keep-date       t)
	     (tramp-password-end-of-line nil)))
  "*Alist of methods for remote files.
This is a list of entries of the form (NAME PARAM1 PARAM2 ...).
Each NAME stands for a remote access method.  Each PARAM is a
pair of the form (KEY VALUE).  The following KEYs are defined:
  * `tramp-remote-sh'
    This specifies the Bourne shell to use on the remote host.  This
    MUST be a Bourne-like shell.  It is normally not necessary to set
    this to any value other than \"/bin/bash\": Tramp wants to use a shell
    which groks tilde expansion, but it can search for it.  Also note
    that \"/bin/bash\" exists on all Unixen, this might not be true for
    the value that you decide to use.  You Have Been Warned.
  * `tramp-login-program'
    This specifies the name of the program to use for logging in to the
    remote host.  This may be the name of rsh or a workalike program,
    or the name of telnet or a workalike, or the name of su or a workalike.
  * `tramp-login-args'
    This specifies the list of arguments to pass to the above
    mentioned program.  Please note that this is a list of list of arguments,
    that is, normally you don't want to put \"-a -b\" or \"-f foo\"
    here.  Instead, you want a list (\"-a\" \"-b\"), or (\"-f\" \"foo\").
    There are some patterns: \"%h\" in this list is replaced by the host
    name, \"%u\" is replaced by the user name, \"%p\" is replaced by the
    port number, and \"%%\" can be used to obtain a literal percent character.
    If a list containing \"%h\", \"%u\" or \"%p\" is unchanged during
    expansion (i.e. no host or no user specified), this list is not used as
    argument.  By this, arguments like (\"-l\" \"%u\") are optional.
    \"%t\" is replaced by the temporary file name produced with
    `tramp-make-tramp-temp-file'.  \"%k\" indicates the keep-date
    parameter of a program, if exists.
  * `tramp-copy-program'
    This specifies the name of the program to use for remotely copying
    the file; this might be the absolute filename of rcp or the name of
    a workalike program.
  * `tramp-copy-args'
    This specifies the list of parameters to pass to the above mentioned
    program, the hints for `tramp-login-args' also apply here.
  * `tramp-copy-keep-date'
    This specifies whether the copying program when the preserves the
    timestamp of the original file.
  * `tramp-copy-keep-tmpfile'
    This specifies whether a temporary local file shall be kept
    for optimization reasons (useful for \"rsync\" methods).
  * `tramp-copy-recursive'
    Whether the operation copies directories recursively.
  * `tramp-default-port'
    The default port of a method is needed in case of gateway connections.
    Additionally, it is used as indication which method is prepared for
    passing gateways.
  * `tramp-gw-args'
    As the attribute name says, additional arguments are specified here
    when a method is applied via a gateway.
  * `tramp-password-end-of-line'
    This specifies the string to use for terminating the line after
    submitting the password.  If this method parameter is nil, then the
    value of the normal variable `tramp-default-password-end-of-line'
    is used.  This parameter is necessary because the \"plink\" program
    requires any two characters after sending the password.  These do
    not have to be newline or carriage return characters.  Other login
    programs are happy with just one character, the newline character.
    We use \"xy\" as the value for methods using \"plink\".

What does all this mean?  Well, you should specify `tramp-login-program'
for all methods; this program is used to log in to the remote site.  Then,
there are two ways to actually transfer the files between the local and the
remote side.  One way is using an additional rcp-like program.  If you want
to do this, set `tramp-copy-program' in the method.

Another possibility for file transfer is inline transfer, i.e. the
file is passed through the same buffer used by `tramp-login-program'.  In
this case, the file contents need to be protected since the
`tramp-login-program' might use escape codes or the connection might not
be eight-bit clean.  Therefore, file contents are encoded for transit.
See the variables `tramp-local-coding-commands' and
`tramp-remote-coding-commands' for details.

So, to summarize: if the method is an out-of-band method, then you
must specify `tramp-copy-program' and `tramp-copy-args'.  If it is an
inline method, then these two parameters should be nil.  Methods which
are fit for gateways must have `tramp-default-port' at least.

Notes:

When using `su' or `sudo' the phrase `open connection to a remote
host' sounds strange, but it is used nevertheless, for consistency.
No connection is opened to a remote host, but `su' or `sudo' is
started on the local host.  You should specify a remote host
`localhost' or the name of the local host.  Another host name is
useful only in combination with `tramp-default-proxies-alist'.")
