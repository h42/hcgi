import Prelude hiding (id,div,span)
import Control.Monad.State
import Xhtml

myhtml = do
    h1
    q"Header 1"
    h1_

    div ! hclass "d1" ! id "id11" >>> do
	p ! hclass "c1" ! id "id12"
	span ! hclass "span 1"  >>> q "this is paragraph 1."  >>> span_
	br
	q"this is paragraph 1a"
	p_
	p >>> q"this is paragraph 2" >>> p_
    div_

    div ! hclass "d2" ! id "id21" >>> do
	p ! hclass "c1" ! id "id22" ! title "This is div 2 par 1"
	q"this is paragraph 1."
	br
	q"this is paragraph 1a"
	p_
	p >>> q "this is paragraph 2" >>> p_
    div_

main = do
    putStr $ def_http_hdr ++ render (def_html "Test Page" myhtml )

