" gradle syntax highlighting
au BufNewFile,BufRead *.gradle set filetype=groovy
autocmd BufNewFile,BufRead *.xml
\ let lines  = getline(1).getline(2).getline(3).getline(4).getline(5)
   \|if lines =~? '<Description'
   \|  set filetype=fortifydescription
   \|endif
autocmd BufNewFile,BufRead *.nst setfiletype fortifynst
autocmd BufNewFile,BufRead *.rules set filetype=fortifyrulepack
autocmd BufNewFile,BufRead *.xml
\ let lines  = getline(1).getline(2).getline(3).getline(4).getline(5)
   \|if lines =~? '<Rule'
   \|  set filetype=fortifyrulepack
   \|endif
" recognize .snippet files
if has("autocmd")
    autocmd BufNewFile,BufRead *.snippets setf snippets
endif
" Go dep and Rust use several TOML config files that are not named with .toml.
autocmd BufNewFile,BufRead *.toml,Gopkg.lock,Cargo.lock,*/.cargo/config set filetype=toml
" Dockerfile
autocmd BufRead,BufNewFile Dockerfile set ft=Dockerfile
autocmd BufRead,BufNewFile Dockerfile* setf Dockerfile
autocmd BufRead,BufNewFile *.dock setf Dockerfile
autocmd BufRead,BufNewFile *.[Dd]ockerfile setf Dockerfile
" docker-compose.yml
autocmd BufRead,BufNewFile docker-compose*.{yaml,yml}* set ft=docker-compose
autocmd BufNewFile,BufRead *.json setlocal filetype=json
autocmd BufNewFile,BufRead *.jsonp setlocal filetype=json
autocmd BufNewFile,BufRead *.geojson setlocal filetype=json
au BufRead,BufNewFile *.swift setf swift
" markdown filetype file
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn} set filetype=markdown
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn}.{des3,des,bf,bfa,aes,idea,cast,rc2,rc4,rc5,desx} set filetype=markdown
fun! s:DetectScala()
    if getline(1) =~# '^#!\(/usr\)\?/bin/env\s\+scalas\?'
        set filetype=scala
    endif
endfun

au BufRead,BufNewFile *.scala,*.sc set filetype=scala
au BufRead,BufNewFile * call s:DetectScala()

" Install vim-sbt for additional syntax highlighting.
au BufRead,BufNewFile *.sbt setfiletype sbt.scala
