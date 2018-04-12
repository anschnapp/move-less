function! CheckAfterCursorChanges() 
    if exists("b:line") && b:line
        let l:currentLine = line(".")
        if b:line != l:currentLine

            if b:upCount > 1
                exec b:line + 1 . 'global/\v./normal! zd'
            endif
            if b:downCount > 1
                exec b:line - 1 . 'global/\v./normal! zd'
            endif
            let b:line = 0
            autocmd! moveLessListenIfJumpsEnded CursorMoved <buffer>
        endif
    endif
endfunction
let s:bufferList = []

function! FoldJump()
    let l:result = 'j'
    let b:line = line(".")
    let b:upCount = 0
    let b:downCount = 0
    let l:mode = 'initial'
    while l:result ==? 'j' || l:result ==? 'k' || l:result ==# 'l' || l:result ==# 'h'
        let l:result = ''
        while l:result == ''
            let l:result = nr2char(getchar(1))
            sleep 20m
        endwhile
        
        if l:result ==? 'j' || l:result ==? 'k' || l:result ==# 'l' || l:result ==# 'h'
            let l:result = nr2char(getchar())
        endif

        let l:endLine = line("$")
        let l:firstLine = 1

        
        if l:result ==# 'j'
            if l:mode ==# 'down'
                if l:endLine - b:line - b:downCount > &scroll  
                    let b:downCount = FoldAndAdjustCount(b:downCount, &scroll, 0)
                endif
            else
                echom 'change to fold down mode'
                let l:mode = 'down'
            endif
            exec "normal! zt"
            redraw
        elseif l:result ==# 'J'
            if l:mode ==# 'down'
                if b:downCount > 0
                    if b:downCount > &scroll
                        let l:step = &scroll * -1
                    else
                        let l:step = b:downCount * -1
                    endif
                    let b:downCount = FoldAndAdjustCount(b:downCount, l:step, 0)
                endif
            else
                echom 'change to fold down mode'
                let l:mode = 'down'
            endif
            exec "normal! zt"
            redraw
        elseif l:result ==# 'k'
            if l:mode ==# 'up'
                if  b:line - l:firstLine - b:upCount > &scroll  
                    let b:upCount = FoldAndAdjustCount(b:upCount, &scroll, 1)
                endif
            else
                echom 'change to fold up mode'
                let l:mode = 'up'
            endif
            exec "normal! z-"
            redraw
        elseif l:result ==# 'K'
            if l:mode ==# 'up'
                if b:upCount > 0
                    if b:upCount > &scroll
                        let l:step = &scroll * -1
                    else
                        let l:step = b:upCount * -1
                    endif
                    let b:upCount = FoldAndAdjustCount(b:upCount, l:step, 1)
                endif
            else
                echom 'change to fold up mode'
                let l:mode = 'up'
            endif
            exec "normal! z-"
            redraw
        elseif l:result ==# 'l'
            if l:mode ==# 'both'
                if l:endLine - b:line - b:downCount > &scroll/2  
                    let b:downCount = FoldAndAdjustCount(b:downCount, &scroll/2, 0)
                endif
                if b:line - l:firstLine - b:upCount > &scroll/2  
                    let b:upCount = FoldAndAdjustCount(b:upCount, &scroll/2, 1)
                endif
            else
                echom 'change to fold both mode'
                let l:mode = 'both'
            endif
            exec "normal! z."
            redraw
        elseif l:result ==# 'h'
            if l:mode ==# 'both'
                if b:downCount > 0
                    if b:downCount > &scroll/2
                        let l:step = &scroll/2 * -1
                    else
                        let l:step = b:downCount * -1
                    endif
                    let b:downCount = FoldAndAdjustCount(b:downCount, l:step, 0)
                endif
                if b:upCount > 0
                    if b:upCount > &scroll/2
                        let l:step = &scroll/2 * -1
                    else
                        let l:step = b:upCount * -1
                    endif
                    let b:upCount = FoldAndAdjustCount(b:upCount, step, 1)
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
            exec b:line - 1 . 'global/\v./normal! zd``'
        endif
        exec ".-" . l:upperRange. ",.-" . l:lowerRange . "fold"
        let l:result = a:count + a:step
    else
        echo 'down'
        let l:lowerRange = 1
        let l:upperRange = a:count + 1 + a:step
        if a:count > 1
            echom 'globalline=' . b:line + 1
            exec b:line + 1 . 'global/\v./normal! zd``'
        endif
        exec ".+" . l:lowerRange . ",.+" . l:upperRange . "fold"
        let l:result = a:count + a:step
    endif
    return l:result
endfunction



"autocmd CursorMoved * exec "normal! zE"
noremap <leader>f :call FoldJump()<cr>
