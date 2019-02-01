" If those mappings change, remember to update the documentation!
let g:MoveLess#Mappings = get(
  \  g:,'MoveLess#Mappings',
  \  {
  \    'FoldBelow': 'j',
  \    'FoldAbove': 'k',
  \    'UnfoldBelow': 'J',
  \    'UnfoldAbove': 'K',
  \    'FoldAboveAndBelowK1': 'l',
  \    'FoldAboveAndBelowK2': 'H',
  \    'UnfoldAboveAndBelowK1': 'h',
  \    'UnfoldAboveAndBelowK2': 'L',
  \    'StopMoveLess': 'p',
  \    'AbortMoveLess': "\<Esc>"
  \  }
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

            " jump to source line and back to here just for creating a jump entry
            " (dont have to check if the user action have already created a action
            " cause sequential duplicates are not recoreded)
            call setpos('.', b:moveLessCursorPosition)
            exec "normal! " . l:currentLine . "gg"
            unlet b:moveLessCursorPosition
            autocmd! moveLessListenIfJumpsEnded CursorMoved <buffer>
        endif
    endif
endfunction

function! s:IsFoldKey(key)
  return a:key ==# g:MoveLess#Mappings['FoldBelow'] || a:key ==# g:MoveLess#Mappings['FoldAbove'] || a:key ==# g:MoveLess#Mappings['FoldAboveAndBelowK1'] || a:key ==# g:MoveLess#Mappings['UnfoldAboveAndBelowK1'] || a:key ==# g:MoveLess#Mappings['FoldAboveAndBelowK2'] || a:key ==# g:MoveLess#Mappings['UnfoldAboveAndBelowK2']
endfunction

function! MoveLessMode()
    let l:result = g:MoveLess#Mappings['FoldBelow'] 
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
    while s:IsFoldKey(l:result)
        let l:result = ''
        while l:result == ''
            let l:result = nr2char(getchar(1))
            sleep 20m
        endwhile
        
        if s:IsFoldKey(l:result) || l:result ==# g:MoveLess#Mappings['StopMoveLess']
            let l:result = nr2char(getchar())
        endif

        let l:endLine = line("$")
        let l:firstLine = 1

        
        if l:result ==# g:MoveLess#Mappings['FoldBelow']
            if l:mode ==# 'down'
                if l:endLine - b:moveLessCursorPosition[1] - b:moveLessDownCount > &scroll  
                    let b:moveLessDownCount = s:FoldAndAdjustCount(b:moveLessDownCount, &scroll, 0)
                endif
            else
                let l:mode = 'down'
            endif
            exec "normal! zt"
            redraw
        elseif l:result ==# g:MoveLess#Mappings['UnfoldBelow']
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
        elseif l:result ==# g:MoveLess#Mappings['FoldAbove']
            if l:mode ==# 'up'
                if  b:moveLessCursorPosition[1] - l:firstLine - b:moveLessUpCount > &scroll  
                    let b:moveLessUpCount = s:FoldAndAdjustCount(b:moveLessUpCount, &scroll, 1)
                endif
            else
                let l:mode = 'up'
            endif
            exec "normal! z-"
            redraw
        elseif l:result ==# g:MoveLess#Mappings['UnfoldAbove']
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
        elseif l:result ==# g:MoveLess#Mappings['FoldAboveAndBelowK1'] || l:result ==# g:MoveLess#Mappings['FoldAboveAndBelowK2']
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
        elseif l:result ==# g:MoveLess#Mappings['UnfoldAboveAndBelowK1'] || l:result ==# g:MoveLess#Mappings['UnfoldAboveAndBelowK2']
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
    if l:result ==# g:MoveLess#Mappings['AbortMoveLess']
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
