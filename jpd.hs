import Html
import Html_def
import Prelude hiding (id,div,span)

myhtml= do
    h1
    q "Header 1"
    h1_

    div ! hclass "d1" ! id "id11" >>> do
	p ! hclass "c1" ! id "id12"
	span ! hclass "span 1"  >>> q "this is paragraph 1."  >>> span_
	br
	b >>> q"this is paragraph 1a" >>> b_
	p >>> q"this is paragraph 2" >>> p_
    div_

    div ! hclass "d2" ! id "id21" >>> do
	p ! hclass "c1" ! id "id22" ! title "This is div 2 par 1"
	q"this is paragraph 1."
	br
	q"this is paragraph 1a"
	p >>> i >>> q "this is paragraph 2" >>> i_ >>> p_
    div_

    big_small
    mycode

big_small = do
    h3 >>> q "xxx header" >>> h3_
    p ! hclass "c1"
    small >>> q"this is small line 1." >>> small_
    br >>> q"Normal line 1"
    br >>> q"Normal line 2"
    br >>> q"Normal line 3"
    let s = "this is big line 1"
    br >>> big >>> q "This is the problem" >>>  big_
    p_

mycode = do
    h2 >>> q"Code example" >>> h2_
    p >>> pre
    q    "close2 :: String -> [String] -> [String] -> ([String],[String])"
    q    "close2 s tags []  = (tags,[])"
    q    "close2 s (e:es) tags"
    q    "    | s == e    = ((etagit s):tags,es)"
    q    "    | otherwise = close2 s es (etagit s:tags)"
    pre_ >>> p_

main = do
    --s <- readFile "jpd.hs"
    putStr $ def_http_hdr ++ render (def_html "Test Page" myhtml )

