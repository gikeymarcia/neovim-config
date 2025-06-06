" check shell scripts for common mistakes
if !exists("shellcheck")
    let shellcheck = 1
    autocmd BufWritePost *.sh,~/.bash* :!shellcheck -x %
endif

setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal tabstop=2
setlocal expandtab
