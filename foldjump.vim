function! FoldJump()
    let l:result = ''
    let l:count = 0
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
