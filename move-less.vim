function! CheckAfterCursorChanges() 
    if exists("b:line") && b:line
        let l:currentLine = line(".")
        if b:line != l:currentLine
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
    let l:mode = 'initial'
    while l:result ==# 'j' || l:result ==# 'k' || l:result ==# 'l' || l:result ==# 'h'
        let l:result = ''
        while l:result == ''
            let l:result = nr2char(getchar(1))
            sleep 20m
        endwhile
        
        if l:result ==# 'j' || l:result ==# 'k' || l:result ==# 'l' || l:result ==# 'h'
            let l:result = nr2char(getchar())
        endif

        let l:endLine = line("$")
        let l:firstLine = 1

        
        if l:result ==# 'j'
            if l:mode ==# 'down'
                if l:endLine - b:line - l:downCount > &scroll  
                    let l:downCount = FoldAndAdjustCount(l:downCount, &scroll, 0)
                endif
            else
                echom 'change to fold down mode'
                let l:mode = 'down'
            endif
            exec "normal! zt"
            redraw
        elseif l:result ==# 'k'
            if l:mode ==# 'up'
                if  b:line - l:firstLine - l:upCount > &scroll  
                    let l:upCount = FoldAndAdjustCount(l:upCount, &scroll, 1)
                endif
            else
                echom 'change to fold up mode'
                let l:mode = 'up'
            endif
            exec "normal! z-"
            redraw
        elseif l:result ==# 'l'
            if l:mode ==# 'both'
                if l:endLine - b:line - l:downCount > &scroll/2  
                    let l:downCount = FoldAndAdjustCount(l:downCount, &scroll/2, 0)
                endif
                if b:line - l:firstLine - l:upCount > &scroll/2  
                    let l:upCount = FoldAndAdjustCount(l:upCount, &scroll/2, 1)
                endif
            else
                echom 'change to fold both mode'
                let l:mode = 'both'
            endif
            exec "normal! z."
            redraw
        elseif l:result ==# 'h'
            if l:mode ==# 'both'
                if l:downCount > 0
                    if l:downCount > &scroll/2
                        let l:step = &scroll/2 * -1
                    else
                        let l:step = l:downCount * -1
                    endif
                    let l:downCount = FoldAndAdjustCount(l:downCount, l:step, 0)
                endif
                if l:upCount > 0
                    if l:upCount > &scroll/2
                        let l:step = &scroll/2 * -1
                    else
                        let l:step = l:upCount * -1
                    endif
                    let l:upCount = FoldAndAdjustCount(l:upCount, step, 1)
                endif
            else
                echom 'change to fold both mode'
                let l:mode = 'both'
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
    return l:result
endfunction



"autocmd CursorMoved * exec "normal! zE"
noremap <leader>f :call FoldJump()<cr>
