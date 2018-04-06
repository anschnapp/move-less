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
    let l:count = 0
    while l:result ==# 'j' || l:result ==# 'k'
        let l:result = ''
        while l:result == ''
            let l:result = nr2char(getchar(1))
        endwhile
        
        if l:result ==# 'j' || l:result ==# 'k'
            let l:result = nr2char(getchar())
            echom 'hit'
        endif
        
        let l:lowerRange = l:count + 1
        let l:upperRange = l:count + 1 + g:step
        if l:result ==# 'j'
            exec ".+" . l:lowerRange . ",.+" . l:upperRange . "fold"
            exec ".-" . l:upperRange. ",.-" . l:lowerRange . "fold"
            exec "normal! z."
            redraw
        elseif l:result ==# 'k'
            exec ".+" . l:lowerRange . ",.+" . l:upperRange . "fold"
            exec ".-" . l:upperRange. ",.-" . l:lowerRange . "fold"
            exec "normal! z."
            redraw
        endif
        let l:count = l:count + g:step
    endwhile
endfunction

"autocmd CursorMoved * exec "normal! zE"
noremap <leader>f :call FoldJump()<cr>
