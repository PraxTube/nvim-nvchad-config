" Comments
syntax match comment "\/\/.*$"
highlight link comment Comment

" Keywords
syntax match keyword "title\:"
highlight link keyword Keyword

" Variable
syntax match var "\$\w\+"
highlight link var Identifier

" Option
syntax match option "->.*$"
highlight link option String

" Command
syntax match command "<<"
syntax match command ">>"
syntax match command "{"
syntax match command "}"
highlight link command Number

" Constants
syntax keyword constant false true
highlight link constant Constant

" Function calls
syntax keyword call set jump if else endif wait declare
highlight link call Function

" Special
syntax match special "---"
syntax match special "==="
highlight link special Special
