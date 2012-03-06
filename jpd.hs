import Html
import Html_def
import Prelude hiding (id,div,span)

myhtml= do
    h1
    s "HCGI Demo Program"
    h1_

    div # do -- Simple formatting
	h3#s"Simple Formatting" #h3_
	p
	s "This is the first paragraph. we can" # b # s"bold" # b_
	s "things or" # i # s"italicize things." # i_
	br
	s "This sample program will eventually show a great many features"
	s "of html"

	span ! h_class "span 1"
	br
	s"This sentence is enclosed in a span which we can format separately"
	span_

	p_
    div_

    div # do -- Preformatted text
	h3 # s"Preformatted Text" # h3_
	p
	s"This paragraph will be used to demonstrate preformatted code."
	--br
	s"like this code snippet"
	pre
	mycode
	pre_
	p_
    div_

    div # do -- Big / Small
	h3 # s"Demonstrate big/small" # h3_
	small # s"this is small line 1." # small_
	br # s"Normal line 1"
	br # s"Normal line 2"
	br # s"Normal line 3"
	let sval = "this is big line 1"
	br # big # s sval # big_
    div_

    div # do
	h3 # s"Demonstrate Simple Images" # h3_
	p
	s"This is a caption for the image."
	br
	img ! src "http://localhost/plumber.jpg" ! alt "plumber.jpg"
	    ! width "150" ! height  "180" ! "/"
	br
	s"This should go under the image"
	p_
    div_


mycode = do
    s    "close2 :: String -> [String] -> [String] -> ([String],[String])"
    s    "close2 s tags []  = (tags,[])"
    s    "close2 s (e:es) tags"
    s    "    | s == e    = ((etagit s):tags,es)"
    s    "    | otherwise = close2 s es (etagit s:tags)"

main = do
    --s <- readFile "jpd.hs"
    putStr $ def_http_hdr ++ render (def_html "Test Page" myhtml )

