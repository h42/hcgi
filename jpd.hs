import Html
import Html_def
import Prelude hiding (id,div,span)

myhtml= do
    h1
    s "Header 1"
    h1_

    div ! h_class "d1" ! id "id11" >>> do
	blockquote
	p ! h_class "c1" ! id "id12"
	span ! h_class "span 1"  >>> s "this is paragraph 1."  >>> span_
	br
	img ! src "http://localhost/plumber.jpg" ! alt "plumber.jpg"
	    ! width "200" ! height  "240" ! "/"
	br
	b >>> s"this is paragraph 1a" >>> b_
	p >>> s"this is paragraph 2" >>> p_
	blockquote_
    div_

    div ! h_class "d2" ! id "id21" >>> do
	p ! h_class "c1" ! id "id22" ! title "This is div 2 par 1"
	s"this is paragraph 1."
	br
	s"this is paragraph 1a"
	p >>> i >>> s"this is paragraph 2" >>> i_ >>> p_
    div_

    big_small
    mycode

big_small = do
    h3 >>> s"xxx header" >>> h3_
    p ! h_class "c1"
    small >>> s"this is small line 1." >>> small_
    br >>> s"Normal line 1"
    br >>> s"Normal line 2"
    br >>> s"Normal line 3"
    let sval = "this is big line 1"
    br >>> big >>> s sval >>>  big_
    p_

mycode = do
    h2 >>> s"Code example" >>> h2_
    p >>> pre
    s    "close2 :: String -> [String] -> [String] -> ([String],[String])"
    s    "close2 s tags []  = (tags,[])"
    s    "close2 s (e:es) tags"
    s    "    | s == e    = ((etagit s):tags,es)"
    s    "    | otherwise = close2 s es (etagit s:tags)"
    pre_ >>> p_

main = do
    --s <- readFile "jpd.hs"
    putStr $ def_http_hdr ++ render (def_html "Test Page" myhtml )

