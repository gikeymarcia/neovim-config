" check shell scripts for common mistakes
if !exists("shellcheck")
    let shellcheck = 1
    autocmd BufWritePost *.sh,~/.bash* :!shellcheck -x %
endif

setlocal tabstop=8
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal tabstop=4
