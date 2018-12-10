" If those mappings change, remember to update the documentation!
let g:MoveLess#Mappings =
  \ extend(
  \   {
  \     'FoldDown': 'j',
  \     'FoldUp': 'k',
  \     'UnfoldDown': 'J',
  \     'UnfoldUp': 'K',
  \     'FoldUpAndDownK1': 'l',
  \     'FoldUpAndDownK2': 'H',
  \     'UnfoldUpAndDownK1': 'h',
  \     'UnfoldUpAndDownK2': 'L',
  \     'StopMoveLess': 'p',
  \     'UndoMoveLess': "\<Esc>"
  \   },
  \   get(g:, 'MoveLess#Mappings', {})
  \ )


function! s:CheckAfterCursorChanges() 
    if exists("b:moveLessCursorPosition") && b:moveLessCursorPosition[1]
        let l:currentLine = line(".")
        if (l:currentLine < b:moveLessCursorPosition[1] - b:moveLessUpCount - 1) || (l:currentLine > b:moveLessCursorPosition[1] + b:moveLessDownCount)

            if b:moveLessUpCount > 1
                call s:Unfold(1)
            endif
            if b:moveLessDownCount > 1
                call s:Unfold(0)
            endif
            unlet b:moveLessCursorPosition
            autocmd! moveLessListenIfJumpsEnded CursorMoved <buffer>
        endif
    endif
endfunction

function! MoveLessMode()
    let l:result = g:MoveLess#Mappings['FoldDown'] 
    if exists("b:moveLessModePermanentEnded") && b:moveLessModePermanentEnded
        if b:moveLessUpCount > 1
            call s:Unfold(1)
        endif
        if b:moveLessDownCount > 1
            call s:Unfold(0)
        endif
        unlet b:moveLessCursorPosition
        unlet b:moveLessModePermanentEnded
    endif
    " only initialize new state values if last move-less mode was succesfully
    " ened, otherwise continue last mode
    if !exists("b:moveLessCursorPosition") || !b:moveLessCursorPosition[1]
        let b:moveLessCursorPosition = getcurpos()
        let b:moveLessUpCount = 0
        let b:moveLessDownCount = 0
    else
        " go to line where the actual move-less mode was original started
        call setpos('.', b:moveLessCursorPosition)
    endif

    let l:mode = 'initial'
    while l:result ==? g:MoveLess#Mappings['FoldDown'] || l:result ==? g:MoveLess#Mappings['FoldUp'] || l:result ==? g:MoveLess#Mappings['FoldUpAndDownK1'] || l:result ==? g:MoveLess#Mappings['UnfoldUpAndDownK1']
        let l:result = ''
        while l:result == ''
            let l:result = nr2char(getchar(1))
            sleep 20m
        endwhile
        
        if l:result ==? g:MoveLess#Mappings['FoldDown'] || l:result ==? g:MoveLess#Mappings['FoldUp'] || l:result ==? g:MoveLess#Mappings['FoldUpAndDownK1'] || l:result ==? g:MoveLess#Mappings['UnfoldUpAndDownK1'] || l:result ==# g:MoveLess#Mappings['StopMoveLess']
            let l:result = nr2char(getchar())
        endif

        let l:endLine = line("$")
        let l:firstLine = 1

        
        if l:result ==# g:MoveLess#Mappings['FoldDown']
            if l:mode ==# 'down'
                if l:endLine - b:moveLessCursorPosition[1] - b:moveLessDownCount > &scroll  
                    let b:moveLessDownCount = s:FoldAndAdjustCount(b:moveLessDownCount, &scroll, 0)
                endif
            else
                let l:mode = 'down'
            endif
            exec "normal! zt"
            redraw
        elseif l:result ==# g:MoveLess#Mappings['UnfoldDown']
            if l:mode ==# 'down'
                if b:moveLessDownCount > 0
                    if b:moveLessDownCount > &scroll
                        let l:step = &scroll * -1
                    else
                        let l:step = b:moveLessDownCount * -1
                    endif
                    let b:moveLessDownCount = s:FoldAndAdjustCount(b:moveLessDownCount, l:step, 0)
                endif
            else
                let l:mode = 'down'
            endif
            exec "normal! zt"
            redraw
        elseif l:result ==# g:MoveLess#Mappings['FoldUp']
            if l:mode ==# 'up'
                if  b:moveLessCursorPosition[1] - l:firstLine - b:moveLessUpCount > &scroll  
                    let b:moveLessUpCount = s:FoldAndAdjustCount(b:moveLessUpCount, &scroll, 1)
                endif
            else
                let l:mode = 'up'
            endif
            exec "normal! z-"
            redraw
        elseif l:result ==# g:MoveLess#Mappings['UnfoldUp']
            if l:mode ==# 'up'
                if b:moveLessUpCount > 0
                    if b:moveLessUpCount > &scroll
                        let l:step = &scroll * -1
                    else
                        let l:step = b:moveLessUpCount * -1
                    endif
                    let b:moveLessUpCount = s:FoldAndAdjustCount(b:moveLessUpCount, l:step, 1)
                endif
            else
                let l:mode = 'up'
            endif
            exec "normal! z-"
            redraw
        elseif l:result ==# g:MoveLess#Mappings['FoldUpAndDownK1'] || l:result ==# g:MoveLess#Mappings['FoldUpAndDownK2']
            if l:mode ==# 'both'
                if l:endLine - b:moveLessCursorPosition[1] - b:moveLessDownCount > &scroll/2  
                    let b:moveLessDownCount = s:FoldAndAdjustCount(b:moveLessDownCount, &scroll/2, 0)
                endif
                if b:moveLessCursorPosition[1] - l:firstLine - b:moveLessUpCount > &scroll/2  
                    let b:moveLessUpCount = s:FoldAndAdjustCount(b:moveLessUpCount, &scroll/2, 1)
                endif
            else
                let l:mode = 'both'
            endif
            exec "normal! z."
            redraw
        elseif l:result ==# g:MoveLess#Mappings['UnfoldUpAndDownK1'] || l:result ==# g:MoveLess#Mappings['FoldUpAndDownK2']
            if l:mode ==# 'both'
                if b:moveLessDownCount > 0
                    if b:moveLessDownCount > &scroll/2
                        let l:step = &scroll/2 * -1
                    else
                        let l:step = b:moveLessDownCount * -1
                    endif
                    let b:moveLessDownCount = s:FoldAndAdjustCount(b:moveLessDownCount, l:step, 0)
                endif
                if b:moveLessUpCount > 0
                    if b:moveLessUpCount > &scroll/2
                        let l:step = &scroll/2 * -1
                    else
                        let l:step = b:moveLessUpCount * -1
                    endif
                    let b:moveLessUpCount = s:FoldAndAdjustCount(b:moveLessUpCount, step, 1)
                endif
            else
                let l:mode = 'both'
            endif
            exec "normal! z."
            redraw
        endif
    endwhile
    if l:result ==# g:MoveLess#Mappings['UndoMoveLess']
        if b:moveLessUpCount > 1
            call s:Unfold(1)
        endif
        if b:moveLessDownCount > 1
            call s:Unfold(0)
        endif
        unlet b:moveLessCursorPosition
    elseif l:result ==# g:MoveLess#Mappings['StopMoveLess']
        let b:moveLessModePermanentEnded = 1
        " if p is clicked the folding should be permaent until someone would clear it with move less mode <ESC> or make a new move less mode navigation
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
    let l:currentposition = getcurpos()
    if a:up
        let l:unfoldLine = b:moveLessCursorPosition[1] - 1
    else
        let l:unfoldLine = b:moveLessCursorPosition[1] + 1
    endif
    let l:foldposition = [b:moveLessCursorPosition[0], l:unfoldLine, 1, b:moveLessCursorPosition[3]]
    call setpos('.', l:foldposition)
    exec 'normal! zd'
    call setpos('.', l:currentposition)
endfunction


silent! noremap <unique> <leader>m :call MoveLessMode()<cr>
