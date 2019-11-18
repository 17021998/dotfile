call plug#begin()
" FZF for searching around
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
" Some Git stuff
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
" EditorConfig
Plug 'editorconfig/editorconfig-vim'
" Execute code in current buffer
Plug 'huytd/vim-quickrun'
" Language support things
Plug 'sheerun/vim-polyglot'
Plug 'rust-lang/rust.vim'
" LSP support
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Fancy UI stuff
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'itchyny/lightline.vim'
Plug 'arcticicestudio/nord-vim'
" Auto root folder switcher
Plug 'airblade/vim-rooter'
" Moving around easier
Plug 'easymotion/vim-easymotion'
" Improving editing experience
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'haya14busa/incsearch.vim'
Plug 'tpope/vim-abolish' " For case perserved subtitue :%S
Plug 'scrooloose/nerdcommenter'
" Display source outline
Plug 'liuchengxu/vista.vim'
call plug#end()

filetype plugin indent on

set hidden
set nobackup
set nowritebackup
set mouse=a " enable mouse for all mode
set wildoptions=pum
set pumblend=20

let g:is_posix = 1

set noswapfile
set nojoinspaces
set nowrap
set number
set ttyfast
set laststatus=2
set ttimeout
set ttimeoutlen=10
set termguicolors
set ignorecase

" Map Emacs like movement in Insert mode
inoremap <C-n> <Down>
inoremap <C-p> <Up>
inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>0

" Remap scrolling
nnoremap <C-k> <C-u>
nnoremap <C-j> <C-d>

set background=dark
let g:nord_bold=0
let g:nord_italic=1
let g:nord_italic_comments=1
let g:nord_uniform_diff_background=1
colorscheme nord

" Some custom style
highlight EasyMotionTargetDefault guifg=#ffb400

if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
	syntax on
endif

set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:·
set list

let $FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
let $FZF_DEFAULT_OPTS = '-m --bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all --color fg:#D8DEE9,bg:#2E3440,hl:#A3BE8C,fg+:#D8DEE9,bg+:#434C5E,hl+:#A3BE8C --color pointer:#BF616A,info:#434C5E,spinner:#434C5E,header:#434C5E,prompt:#81A1C1,marker:#EBCB8B'

command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
set grepprg=rg\ --vimgrep
nnoremap \ :Find<SPACE>

set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set tabstop=2
set softtabstop=2
set shiftwidth=2
set shiftround
set expandtab

set autoindent
set smartindent

map mm <Plug>NERDCommenterToggle


map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

let mapleader=" "
nnoremap <Leader>pf :Files<CR>
nnoremap <Leader>pr :History<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>l :vsplit<CR>
nnoremap <Leader>k :split<CR>
nnoremap <Leader>wh :wincmd h<CR>
nnoremap <Leader>wl :wincmd l<CR>
nnoremap <Leader>wk :wincmd k<CR>
nnoremap <Leader>wj :wincmd j<CR>
nnoremap <Leader>w= :wincmd =<CR>
nnoremap <Leader>e :QuickRunExecute<CR>
nnoremap <Leader>wb :e#<CR>
nnoremap <Leader>qq :bd<CR>
nnoremap <Leader>ss :mksession! .work<CR>
nnoremap <Leader>sr :so .work<CR>
nnoremap <Leader><Leader>r :so ~/.config/nvim/init.vim<CR>
nnoremap <Leader>n :NERDTree<CR>
nnoremap <Leader>f :NERDTreeFind<CR>
nnoremap <Leader>nc :NERDTree
nnoremap <Leader><Leader>o :Vista coc<CR>
nnoremap <C-o> :CocList outline<CR>

"Buffer
nnoremap <Leader>tn :tabn<CR>
nnoremap <Leader>tp :tabp<CR>
nnoremap <Leader>tc :tabe<CR>
nnoremap <Leader>tx :tabclose<CR>

" Git
nnoremap <Leader>ggn :GitGutterNextHunk<CR>
nnoremap <Leader>ggp :GitGutterPrevHunk<CR>

" Turn off whitespaces compare and folding in vimdiff
set splitright
silent! set splitvertical
set diffopt+=iwhite
set diffopt+=vertical
nnoremap <Leader>1 :diffget 1<CR>:diffupdate<CR>
nnoremap <Leader>2 :diffget 2<CR>:diffupdate<CR>

set relativenumber
set clipboard=unnamed

function! DeleteCurrentFileAndBuffer()
  call delete(expand('%'))
  bdelete!
endfunction

function! NearestMethodOrFunction() abort
  let l:method = get(b:, 'vista_nearest_method_or_function', '')
  if l:method != ''
    let l:method = '[' . l:method . ']'
  endif
  return l:method
endfunction

function! DrawGitBranchInfo()
  let branch = fugitive#head()
  return len(branch) > 0 ? " " . branch : ""
endfunction

let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'cocstatus' ], [ 'filename', 'nearmethod' ] ],
      \   'right': [ [ 'icongitbranch', 'percent', 'lineinfo', 'filetype' ] ]
      \ },
      \ 'component': { 'lineinfo': ' %3l:%-2v' },
      \ 'component_function': {
      \   'icongitbranch': 'DrawGitBranchInfo',
      \   'iconline': 'DrawLineInfo',
      \   'gitbranch': 'fugitive#head',
      \   'cocstatus': 'coc#status',
      \   'filename': 'LightLineFilename',
      \   'nearmethod': 'NearestMethodOrFunction'
      \ },
      \ }

function! LightLineFilename()
  let name = ""
  let subs = split(expand('%'), "/")
  let i = 1
  for s in subs
    let parent = name
    if  i == len(subs)
      let name = parent . '/' . s
    elseif i == 1
      let name = s
    else
      let name = parent . '/' . strpart(s, 0, 10)
    endif
    let i += 1
  endfor
  return name
endfunction

set statusline+=%{NearestMethodOrFunction()}
" Use auocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
 "autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

set shortmess+=c
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Use L to highlight the symbol under the cursor
nnoremap <silent> L :call CocActionAsync('highlight')<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Remap for format selected region
xmap <leader><leader>f  <Plug>(coc-format-selected)
nmap <leader><leader>f  <Plug>(coc-format-selected)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

function! StatusDiagnostic() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, 'E' . info['error'])
  endif
  if get(info, 'warning', 0)
    call add(msgs, 'W' . info['warning'])
  endif
  return join(msgs, ' ') . ' ' . get(g:, 'coc_status', '')
endfunction

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{StatusDiagnostic()}

" Vim easymotion
nmap <silent> ;; <Plug>(easymotion-overwin-f)
nmap <silent> ;l <Plug>(easymotion-overwin-line)

" VSCode a-like multiple cursor
nmap <expr> <silent> <C-d> <SID>select_current_word()
function! s:select_current_word()
  if !get(g:, 'coc_cursors_activated', 0)
    return "\<Plug>(coc-cursors-word)"
  endif
  return "*\<Plug>(coc-cursors-word):nohlsearch\<CR>"
endfunc

" Show the style name of thing under the cursor
" Shamelessly taken from https://github.com/tpope/vim-scriptease
function! FaceNames(...) abort
  if a:0
    let [line, col] = [a:1, a:2]
  else
    let [line, col] = [line('.'), col('.')]
  endif
  return reverse(map(synstack(line, col), 'synIDattr(v:val,"name")'))
endfunction

function! DescribeFace(count) abort
  if a:count
    let name = get(FaceNames(), a:count-1, '')
    if name !=# ''
      return 'syntax list '.name
    endif
  else
    echo join(FaceNames(), ' ')
  endif
  return ''
endfunction

nnoremap zs :<C-U>exe DescribeFace(v:count)<CR>

" Auto change root of the project
let g:rooter_change_directory_for_non_project_files = 'current'
let g:rooter_patterns = ['Cargo.tom', 'package.json', '.git/']

set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

function! OpenFloatTerm()
  let height = float2nr((&lines-2)/1.5)
  let row = float2nr((&lines - height) / 2)
  let width = float2nr(&columns / 1.5)
  let col = float2nr((&columns - width) / 2)
  "Border window
  let border_opts = {
        \'relative':'editor',
        \'row': row -1,
        \'col' : col-2,
        \'width': width + 4,
        \'height': height + 2,
        \'style': 'minimal'
        \}
  let border_buf = nvim_create_buf(0, 1)
  let s:border_win = nvim_open_win(border_buf, 1, border_opts)
  "Main
  let opts = {
        \'relative':'editor',
        \'row' : row,
        \'col':col,
        \'width': width,
        \'height': height,
        \'style':'minimal'
        \}
  let buf = nvim_create_buf(0 ,1)
  let win = nvim_open_win(buf, 1, opts)
  terminal
  startinsert

  autocmd TermClose * ++once :q | call nvim_win_close(s:border_win, 1)
endfunction

" Float Terminal
nnoremap <Leader>t :call OpenFloatTerm()

