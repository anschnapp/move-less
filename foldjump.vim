
function! CheckAfterCursorChanges() 
    if exists("b:line") && b:line
        let l:currentLine = line(".")
        if b:line != l:currentLine
            echom 'b:line=' . b:line
            echom 'l:currentLine=' . l:currentLine
            let b:line = 0
            exec "normal zR"
        endif
    endif
endfunction

augroup listenIfJumpsEnded
	autocmd!
	autocmd CursorMoved * call CheckAfterCursorChanges()
augroup end 

function! FoldJumpManually()
    let l:result = '1'
    let b:line = line(".")
    while l:result ==# '1' || l:result ==# 'j' || l:result ==# 'k'
        let l:result = nr2char(getchar())
        
        if l:result ==# 'j'
            exec "normal! jV19jzfkzt"
            redraw
        elseif l:result ==# 'k'
            exec "normal! kV19kzfjzb"
            redraw
        elseif l:result ==# 'f'
        endif

    endwhile
endfunction

function! FoldJump()
    let l:result = ''
    let l:count = 0
    let b:line = line(".")
    while l:result ==# ''
        let l:result = nr2char(getchar(1))
        echom 'result2 is: ' . l:result
        sleep 100m 

        let l:lowerRange = l:count + 1
        let l:upperRange = l:count + 2

        exec ".+" . l:lowerRange . ",.+" . l:upperRange . "fold"
        exec ".-" . l:upperRange. ",.-" . l:lowerRange . "fold"
        exec "normal! z."
        redraw
        let l:count = l:count + 1
    endwhile
    
endfunction
"autocmd CursorMoved * exec "normal! zE"
noremap <leader>f :call FoldJump()<cr>
noremap <leader>F :call FoldJumpManually()<cr>
