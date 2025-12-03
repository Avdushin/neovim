" ---------- БАЗОВЫЕ НАСТРОЙКИ ----------
set nocompatible
filetype plugin indent on

set number
set relativenumber
set hidden
set mouse=a
set clipboard=unnamedplus

set tabstop=4
set shiftwidth=4
set expandtab
set termguicolors
set encoding=utf-8

set splitright
set splitbelow

" ВСЕГДА показывать строку вкладок
set showtabline=2

" Лидер-клавиша
let mapleader = " "

" Разделители сплитов
hi VertSplit guibg=NONE guifg=#555555 ctermbg=NONE

" NERDTree фон
hi NERDTreeNormal guibg=NONE ctermbg=NONE

" ---------- НАСТРОЙКИ ДЛЯ vim-visual-multi ----------
" Полностью отключаем дефолтные маппинги, чтобы плагин не трогал <C-n>
let g:VM_default_mappings = 0
let g:VM_maps = {}
let g:VM_maps['Add Cursor Down']     = '<A-S-Down>'
let g:VM_maps['Add Cursor Up']       = '<A-S-Up>'
let g:VM_maps['Select All']          = '<A-S-a>'
let g:VM_maps['Exit']                = '<Esc>'
" (опционально можно добавить поиск под курсором на Alt+n)
" let g:VM_maps['Find Under']         = '<A-n>'
" let g:VM_maps['Find Subword Under'] = '<A-n>'

" ---------- PLUGINS (vim-plug) ----------
call plug#begin('~/.config/nvim/plugged')

" UI
Plug 'vim-airline/vim-airline'
Plug 'ryanoasis/vim-devicons'

" Themes
Plug 'morhetz/gruvbox'

" Файловое дерево и поиск
Plug 'preservim/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'

" Терминал во всплывающем окне
Plug 'voldikss/vim-floaterm'

" LSP / автодополнение
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Multi-cursor
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" Markdown + превью
Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install', 'for': ['markdown', 'vim-plug'] }
Plug 'MeanderingProgrammer/markdown.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Теги (авто-rename HTML/XML)
Plug 'AndrewRadev/tagalong.vim'

" Языки / синтаксис
Plug 'rust-lang/rust.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'cespare/vim-toml'
Plug 'elzr/vim-json'
Plug 'stephpy/vim-yaml'
Plug 'ekalinin/Dockerfile.vim'

call plug#end()

" ---------- ТЕМА ----------
set background=dark
colorscheme gruvbox

" Прозрачные фоны
hi Normal       guibg=NONE ctermbg=NONE
hi NormalNC     guibg=NONE ctermbg=NONE
hi SignColumn   guibg=NONE ctermbg=NONE
hi LineNr       guibg=NONE ctermbg=NONE
hi Folded       guibg=NONE ctermbg=NONE
hi NonText      guibg=NONE ctermbg=NONE
hi EndOfBuffer  guibg=NONE ctermbg=NONE
hi CursorLine   guibg=NONE ctermbg=NONE
hi CursorLineNr guibg=NONE ctermbg=NONE
hi VertSplit    guibg=NONE ctermbg=NONE

" Чтобы при смене темы gruvbox не убивала прозрачность
augroup GruvboxTransparent
  autocmd!
  autocmd ColorScheme gruvbox highlight Normal       guibg=NONE ctermbg=NONE
  autocmd ColorScheme gruvbox highlight NormalNC     guibg=NONE ctermbg=NONE
  autocmd ColorScheme gruvbox highlight SignColumn   guibg=NONE ctermbg=NONE
  autocmd ColorScheme gruvbox highlight LineNr       guibg=NONE ctermbg=NONE
  autocmd ColorScheme gruvbox highlight VertSplit    guibg=NONE ctermbg=NONE
  autocmd ColorScheme gruvbox highlight EndOfBuffer  guibg=NONE ctermbg=NONE
augroup END

" ---------- ОБЩИЕ KEYMAPS ----------
" Выход из insert по jk
inoremap jk <Esc>

" Ctrl+b — дерево файлов (NERDTree)
nnoremap <C-b> :NERDTreeToggle<CR>

" Ctrl+p — поиск файла (CtrlP)
nnoremap <C-p> :CtrlP<CR>

" ---------- ТАБЫ (как во вкладках) ----------
" Ctrl+n — новая вкладка
nnoremap <C-n> :tabnew<CR>
" Ctrl+w — закрыть текущую вкладку
nnoremap <C-w> :tabclose<CR>
" Ctrl+r — следующая вкладка вправо
nnoremap <C-r> :tabnext<CR>
" Ctrl+e — предыдущая вкладка влево
nnoremap <C-e> :tabprevious<CR>

" Ctrl+P: по умолчанию открывать файлы в новой вкладке
let g:ctrlp_open_new_file = 't'

" Двигать строку вниз/вверх (Alt+j / Alt+k)
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
xnoremap <A-j> :m '>+1<CR>gv=gv
xnoremap <A-k> :m '<-2<CR>gv=gv

" ---------- MARKDOWN PREVIEW (через glow в правом сплите) ----------
nnoremap <leader>m <Cmd>RenderMarkdownToggle<CR>

let g:md_preview_winid = -1

function! OpenPreviewWindow()
    if win_gotoid(g:md_preview_winid)
        return
    endif
    rightbelow vsplit
    let g:md_preview_winid = win_getid()
endfunction

function! RenderMarkdown()
    call OpenPreviewWindow()
    call win_gotoid(g:md_preview_winid)
    execute 'terminal glow ' . shellescape(expand('%:p'))
    wincmd h
endfunction

" Команда, чтобы маппинг <leader>m работал
command! RenderMarkdownToggle call RenderMarkdown()

" Автообновление превью по сохранению .md
autocmd BufWritePost *.md call RenderMarkdown()

" ---------- ФОРМАТИРОВАНИЕ ----------
" Ctrl+Shift+I — форматировать через coc-prettier (если установлен)
nnoremap <silent> <C-S-i> :CocCommand prettier.formatFile<CR>
" Альтернатива: форматирование через LSP
nnoremap <silent> <leader>f :call CocActionAsync('format')<CR>

" ---------- ТЕРМИНАЛ (floaterm) ----------
let g:floaterm_keymap_toggle = '<F12>'

nnoremap <F12> :FloatermToggle<CR>
tnoremap <F12> <C-\><C-n>:FloatermToggle<CR>

" Ctrl+Shift+T — тоже тогглит floaterm
nnoremap <C-S-t> :FloatermToggle<CR>
tnoremap <C-S-t> <C-\><C-n>:FloatermToggle<CR>

" Выход из terminal-mode в normal
tnoremap <Esc> <C-\><C-n>

" ---------- vim-airline ----------
let g:airline_powerline_fonts = 1

" ---------- ctrlp ----------
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
set wildignore+=*/node_modules/*,*/target/*,*/dist/*,*/.git/*

" ---------- NERDTree ----------
let g:NERDTreeShowHidden=1
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" ---------- COC (LSP, автодополнение и т.п.) ----------
" completion
inoremap <silent><expr> <TAB>   pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

inoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>   pumvisible() ? "\<C-p>" : "\<Up>"

" goto / refs / etc
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" rename
nmap <leader>rn <Plug>(coc-rename)

" diagnostics
nmap <leader>e :CocDiagnostics<CR>

" форматирование по сохранению
autocmd BufWritePre *.rs,*.go,*.ts,*.tsx,*.js,*.jsx,*.json,*.yml,*.yaml,*.md :silent! call CocAction('format')

" ---------- BETTER COMMENTS ----------
highlight BetterCommentBlue   guifg=#3498DB ctermfg=75
highlight BetterCommentPink   guifg=#FF5FAC ctermfg=205
highlight BetterCommentRed    guifg=#FF2D00 ctermfg=196
highlight BetterCommentOrange guifg=#FF8C00 ctermfg=208
highlight BetterCommentGreen  guifg=#98C379 ctermfg=114
highlight BetterCommentGrey   guifg=#474747 ctermfg=240

function! SetupBetterComments() abort
  syntax match BetterCommentBlue   "\v//\s*@.*$"       containedin=Comment
  syntax match BetterCommentPink   "\v//\s*[?].*$"     containedin=Comment
  syntax match BetterCommentRed    "\v//\s*!.*$"       containedin=Comment
  syntax match BetterCommentOrange "\v//\s*TODO.*$"    containedin=Comment
  syntax match BetterCommentGreen  "\v//\s*[*].*$"     containedin=Comment
  syntax match BetterCommentGrey   "\v//\s*[^@?!*].*$" containedin=Comment
endfunction

augroup BetterCommentsGroup
  autocmd!
  autocmd FileType javascript,typescript,typescriptreact,go,rust,c,cpp call SetupBetterComments()
augroup END

" ---------- ПРОЧЕЕ ----------
" Быстрее перемещаться по wrapped-строкам
nnoremap j gj
nnoremap k gk

augroup FixCtrlNTab
  autocmd!
  autocmd VimEnter * silent! nunmap <C-n> | nnoremap <C-n> :tabnew<CR>
augroup END

