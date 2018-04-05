function! FoldJump()
    let l:result = '1'
    while l:result ==# '1' || l:result ==# 'j' || l:result ==# 'k'
        let l:result = nr2char(getchar())
        
        if l:result ==# 'j'
            exec "normal! jV19jzfk"
            redraw
        elseif l:result ==# 'k'
            exec "normal! kV19kzfj"
            redraw
        else
            "exec "normal! zM"
            exec "normal " .  result
        endif
    endwhile
endfunction
noremap <leader>f :call FoldJump()<cr>
