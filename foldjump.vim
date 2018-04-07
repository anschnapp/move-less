function! CheckAfterCursorChanges() 
    if exists("b:line") && b:line
        let l:currentLine = line(".")
        if b:line != l:currentLine
            echom 'b:line=' . b:line
            echom 'l:currentLine=' . l:currentLine
            let b:line = 0
            exec "normal zE"
        endif
    endif
endfunction

augroup listenIfJumpsEnded
	autocmd!
	autocmd CursorMoved * call CheckAfterCursorChanges()
augroup end 
let g:step = 20

function! FoldJump()
    let l:result = 'j'
    let b:line = line(".")
    let l:upCount = 0
    let l:downCount = 0
    while l:result ==# 'j' || l:result ==# 'k' || l:result ==# 'l'
        let l:result = ''
        while l:result == ''
            let l:result = nr2char(getchar(1))
        endwhile
        
        if l:result ==# 'j' || l:result ==# 'k' || l:result ==# 'l'
            let l:result = nr2char(getchar())
        endif
        
        if l:result ==# 'j'
            let l:lowerRange = l:downCount + 1
            let l:upperRange = l:downCount + 1 + g:step
            exec "normal! zt"
            exec ".+" . l:lowerRange . ",.+" . l:upperRange . "fold"
            let l:downCount = l:downCount + g:step
            redraw
        elseif l:result ==# 'k'
            let l:lowerRange = l:upCount + 1
            let l:upperRange = l:upCount + 1 + g:step
            exec ".-" . l:upperRange. ",.-" . l:lowerRange . "fold"
            exec "normal! z-"
            let l:upCount = l:upCount + g:step
            redraw
        elseif l:result ==# 'l'
            let l:lowerRangeDown = l:downCount + 1
            let l:upperRangeDown = l:downCount + 1 + g:step
            let l:lowerRangeUp = l:upCount + 1
            let l:upperRangeUp = l:upCount + 1 + g:step
            exec ".+" . l:lowerRangeDown. ",.+" . l:upperRangeDown. "fold"
            exec ".-" . l:upperRangeUp .  ",.-" . l:lowerRangeUp . "fold"
            exec "normal! z."
            let l:upCount = l:upCount + g:step
            let l:downCount = l:downCount + g:step
            redraw
        endif
    endwhile
endfunction

"autocmd CursorMoved * exec "normal! zE"
noremap <leader>f :call FoldJump()<cr>
