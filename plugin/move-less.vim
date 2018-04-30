function! s:CheckAfterCursorChanges() 
    if exists("b:line") && b:line
        let l:currentLine = line(".")
        if (l:currentLine < b:line - b:upCount - 1) || (l:currentLine > b:line + b:downCount)

            if b:upCount > 1
                call s:Unfold(1)
            endif
            if b:downCount > 1
                call s:Unfold(0)
            endif
            let b:line = 0
            autocmd! moveLessListenIfJumpsEnded CursorMoved <buffer>
        endif
    endif
endfunction
let s:bufferList = []

function! MoveLessMode()
    let l:result = 'j'
    " only initialize new state values if last move-less mode was succesfully
    " ened, otherwise continue last mode
    if !exists("b:line") || !b:line
        let b:line = line(".")
        let b:upCount = 0
        let b:downCount = 0
    else
        " go to line where the actual move-less mode was original started
        exec "normal! " . b:line . "gg"
    endif

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
                    let b:downCount = s:FoldAndAdjustCount(b:downCount, &scroll, 0)
                endif
            else
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
                    let b:downCount = s:FoldAndAdjustCount(b:downCount, l:step, 0)
                endif
            else
                let l:mode = 'down'
            endif
            exec "normal! zt"
            redraw
        elseif l:result ==# 'k'
            if l:mode ==# 'up'
                if  b:line - l:firstLine - b:upCount > &scroll  
                    let b:upCount = s:FoldAndAdjustCount(b:upCount, &scroll, 1)
                endif
            else
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
                    let b:upCount = s:FoldAndAdjustCount(b:upCount, l:step, 1)
                endif
            else
                let l:mode = 'up'
            endif
            exec "normal! z-"
            redraw
        elseif l:result ==# 'l'
            if l:mode ==# 'both'
                if l:endLine - b:line - b:downCount > &scroll/2  
                    let b:downCount = s:FoldAndAdjustCount(b:downCount, &scroll/2, 0)
                endif
                if b:line - l:firstLine - b:upCount > &scroll/2  
                    let b:upCount = s:FoldAndAdjustCount(b:upCount, &scroll/2, 1)
                endif
            else
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
                    let b:downCount = s:FoldAndAdjustCount(b:downCount, l:step, 0)
                endif
                if b:upCount > 0
                    if b:upCount > &scroll/2
                        let l:step = &scroll/2 * -1
                    else
                        let l:step = b:upCount * -1
                    endif
                    let b:upCount = s:FoldAndAdjustCount(b:upCount, step, 1)
                endif
            else
                let l:mode = 'both'
            endif
            exec "normal! z."
            redraw
        endif
    endwhile
    if l:result ==# "\<esc>"
        if b:upCount > 1
            call s:Unfold(1)
        endif
        if b:downCount > 1
            call s:Unfold(0)
        endif
    else
        augroup moveLessListenIfJumpsEnded
            autocmd! CursorMoved <buffer>
            autocmd CursorMoved <buffer> call s:CheckAfterCursorChanges()
        augroup end
    endif
endfunction

function! s:FoldAndAdjustCount(count, step, up) 
    let l:result = a:count 
    if a:up
        let l:lowerRange = 1
        let l:upperRange = a:count + 1 + a:step
        if a:count > 1
            call s:Unfold(a:up)
        endif
        exec ".-" . l:upperRange. ",.-" . l:lowerRange . "fold"
        let l:result = a:count + a:step
    else
        let l:lowerRange = 1
        let l:upperRange = a:count + 1 + a:step
        if a:count > 1
            call s:Unfold(a:up)
        endif
        exec ".+" . l:lowerRange . ",.+" . l:upperRange . "fold"
        let l:result = a:count + a:step
    endif
    return l:result
endfunction

function! s:Unfold(up)
    if a:up
        let l:unfoldLine = b:line - 1
    else
        let l:unfoldLine = b:line + 1
    endif
    exec 'normal! ' . l:unfoldLine . 'ggzd``'
endfunction


noremap <leader>m :call MoveLessMode()<cr>
