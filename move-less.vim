function! CheckAfterCursorChanges() 
    echom 'ping'
    if exists("b:line") && b:line
        let l:currentLine = line(".")
        if b:line != l:currentLine
            echom 'b:line=' . b:line
            echom 'l:currentLine=' . l:currentLine
            let b:line = 0
            exec "normal zE"
            autocmd! moveLessListenIfJumpsEnded CursorMoved <buffer>
        endif
    endif
endfunction
let s:bufferList = []

function! FoldJump()
    let l:result = 'j'
    let b:line = line(".")
    let l:upCount = 0
    let l:downCount = 0
    while l:result ==# 'j' || l:result ==# 'k' || l:result ==# 'l'
        let l:result = ''
        while l:result == ''
            let l:result = nr2char(getchar(1))
            sleep 20m
        endwhile
        
        if l:result ==# 'j' || l:result ==# 'k' || l:result ==# 'l'
            let l:result = nr2char(getchar())
        endif

        let l:endLine = line("$")
        let l:firstLine = 1

        
        if l:result ==# 'j'
            if l:endLine - b:line - l:downCount > &scroll  
                let l:downCount = FoldAndAdjustCount(l:downCount, &scroll, 0)
                exec "normal! zt"
                redraw
            endif
        elseif l:result ==# 'k'
            if  b:line - l:firstLine - l:upCount > &scroll  
                let l:upCount = FoldAndAdjustCount(l:upCount, &scroll, 1)
                exec "normal! z-"
                redraw
            endif
        elseif l:result ==# 'l'
            if l:endLine - b:line - l:downCount > &scroll/2  
                let l:downCount = FoldAndAdjustCount(l:downCount, &scroll/2, 0)
            endif
            if b:line - l:firstLine - l:upCount > &scroll/2  
                let l:upCount = FoldAndAdjustCount(l:upCount, &scroll/2, 1)
            endif
            exec "normal! z."
            redraw
        endif
    endwhile
    augroup moveLessListenIfJumpsEnded
        autocmd! CursorMoved <buffer>
        autocmd CursorMoved <buffer> call CheckAfterCursorChanges()
    augroup end
endfunction

function! FoldAndAdjustCount(count, step, up) 
    let l:result = a:count 
    if a:up
        let l:lowerRange = 1
        let l:upperRange = a:count + 1 + a:step
        if a:count > 1
            exec "normal! mzkzdj`z"
        endif
        exec ".-" . l:upperRange. ",.-" . l:lowerRange . "fold"
        let l:result = a:count + a:step
    else
        let l:lowerRange = 1
        let l:upperRange = a:count + 1 + a:step
        if a:count > 1
            exec "normal! mzjzdk`z"
        endif
        exec ".+" . l:lowerRange . ",.+" . l:upperRange . "fold"
        let l:result = a:count + a:step
    endif
    echom 'countresult =' . l:result
    return l:result
endfunction



"autocmd CursorMoved * exec "normal! zE"
noremap <leader>f :call FoldJump()<cr>
