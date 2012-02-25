import Prelude hiding (id,div)
import Control.Monad.State
import Xhtml

myhtml_sub = do
    h1
    q "Header 1"
    h1'

    div ! hclass "d1" ! id "id11" >>> do
	p ! hclass "c1" ! id "id12"
	q "this is paragraph 1."
	br'
	q "this is paragraph 1a"
	p'
	p >>> q "this is paragraph 2" >>> p'
    div'

    div ! hclass "d2" ! id "id21" >>> do
	p ! hclass "c1" ! id "id22"
	q "this is paragraph 1."
	br'
	q "this is paragraph 1a"
	p'
	p >>> q "this is paragraph 2" >>> p'
    div'

main = do
    putStr $ def_http_hdr ++ render (def_html "Test Page" myhtml_sub)

