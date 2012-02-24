import Prelude hiding (head,id,div)
import Control.Monad.State
import Xhtml

myhtml :: State Html ()
myhtml = do
    defDoctype
    html ! xmlns defDns

    h_head
    meta ! attr "http-equiv" "Content-Type"  ! attr "content" "text/html;charset=utf-8"  !  "/"
    title >>> q "Test Page" >>> title'
    h_head'

    body
    myhtml_sub
    body'
    html'

myhtml_sub = do
    h1
    q "Header 1"
    h1'

    div ! hclass "d1" ! id "i1" >>> do
	p ! hclass "c1" ! id "i1"
	q "this is paragraph 1."
	br'
	q "this is paragraph 1a"
	p'

	p >>> q "this is paragraph 2" >>> p'
    div'

main = do
    putStr $ cgiPage "text/html" "" myhtml

