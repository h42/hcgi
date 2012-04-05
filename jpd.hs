import Html
import Html_def
import Prelude hiding (id,div,span)

mystyle = do
    style ! h_type "text/css"

    s"body {background-color:#f0f8f8;color:green;}"

    --s"h1 {min-width:400px;max-width:600px;text-align:Left;padding-left:5em}"
    s"div#h1div {padding-left:5em}"
    s"h3 {color:blue}"
    s"img{border:4px solid red;}"

    s"div#toc {min-width:400px;max-width:600px;text-align:left;padding-left:5em}"

    --s"div#list {padding-left:50px}"
    s"div#list {padding-left:5em}"
    s"ul li {padding-top:.5em;padding-bottom:auto}"
    s"ol li {padding-top:.5em;padding-bottom:auto}"
    s"li {color:blue}"
    s"ol li {color:navy}"

    s"div#bigsmall {color:navy}"
    s"div#bigsmall h3 {color:navy}"
    s".bigtext {font-size:150%}"

    s"div#simple  {color:navy}"
    s"p.par1 {color:blue}"

    {- s"#simple {position:absolute}"
    s"#preformatted {position:absolute;bottom}"
    s"#bigsmall {position:absolute;bottom}"
    s"#list {position:absolute;bottom}"
    s"#table {position:absolute; right}"
    s"#images {position:absolute; bottom}"
    -}
    style_

mycode = do  -- used for preformatted demo
    s "close2 :: String -> [String] -> [String] -> ([String],[String])"
    s "close2 s tags []  = (tags,[])"
    s "close2 s (e:es) tags"
    s "    | s == e    = ((etagit s):tags,es)"
    s "    | otherwise = close2 s es (etagit s:tags)"


---------------------------
-- MYHTML
---------------------------
myhtml = do
    div ! id "h1div" >> do
	h1
	s "HCGI Demo Program"
	h1_

---------------------------
-- Table of COntents
---------------------------
    div ! id "toc" >> do
	h3' "Table of Contents"
	p >> blockquote

	a !href "#simple" >> s"Simple Formatting" >> a_
	br
	a !href "#preformatted" >> s"Preformatted Text" >> a_
	br
	a !href "#bigsmall" >> s"Big / Small Text" >> a_
	br
	a !href "#list" >> s"List" >> a_
	br
	a !href "#table" >> s"Table" >> a_
	br
	a !href "#images" >> s"Images" >> a_
	br

	a ! href "http://stackoverflow.com/questions/tagged/haskell"
	  ! accesskey "o" ! tabindex "2"
	s "A link to " >> b >> s"stackoverflow" >> b_
	a_ >> br

	a ! href "http://www.reddit.com/r/haskell/"
	   ! accesskey "r" ! tabindex "1"
	s "A link to " >> b >> s"reddit/r/haskell" >> b_
	a_ >> br

	a ! href "http://http://ALG_3rd.pdf"
	s "A link to a" >> b >> s"PDF" >> b_ >> s"on my computer"
	a_ >> br
	blockquote_ >> p_

---------------------------
-- List
---------------------------
    a ! id "list" ! "/"
    div ! id "list" >> do
	h3'"List Example"
	ul >> do
	    li >> do
		s"This is an outer list item"
		ol >> do
		    li >> s"This is a list item"
		    li >> s"This is a list item"
		    li >> s"This is a list item"
		ol_
	    li >> do
		s"This is an outer list item"
		ol >> do
		    li >> s"This is a list item"
		    li >> s"This is a list item"
		    li >> s"This is a list item"
		ol_
	    li >> do
		s"This is an outer list item"
		ol >> do
		    li >> s"This is a list item"
		    li >> s"This is a list item"
		    li >> s"This is a list item"
		ol_
	ul_

---------------------------
-- TABLE
---------------------------
    a ! id "table" ! "/"
    div ! id "table" >> do
	h3'"Table Example"
	table ! "border=2" >> do
	    tr >> do
		td >> s"table 1 1"
		td >> s"table 1 2"
	    tr >> do
		td >> s"table 2 1"
		td >> s"table 2 2"
	table_

---------------------------
-- Simple
---------------------------
    a ! id "simple" ! "/"
    div ! id "simple" >> do -- Simple formatting
	h3' "Simple Formatting"
	p ! h_class "par1"
	s "This is the first paragraph. we can" >> b >> s"bold" >> b_
	s "things or" >> i >> s"italicize things." >> i_
	br
	s "This sample program will eventually show a great many features"
	s "of html"

	span ! h_class "span 1"
	br
	s"This sentence is enclosed in a span which we can format separately"
	br
	span_

	p
	mapM_ (\_ -> do
	    s "This sentence is just here to fill up space so we can test links better."
	    br) [1..20]


---------------------------
-- PRE
---------------------------
    a ! id "preformatted" ! "/"
    div ! id "preformatted" >> do -- Preformatted text
	h3' "Preformatted Text"
	p
	s"This paragraph will be used to demonstrate preformatted code."
	s"like this code snippet"
	pre
	mycode
	pre_

---------------------------
-- BIG/SMALL
---------------------------
    a ! id "bigsmall" ! "/"
    div ! id "bigsmall" >> do -- Big / Small
	p
	h3' "Demonstrate big/small"
	small' "this is small line 1."
	br >> small' "this is small line 2."
	p
	br >> s"Normal line 1"
	br >> s"Normal line 2"
	p
	br >> s"Normal line 3"
	p
	let sval = "this will be big line 1 when I set BIG style"
	br >> span ! h_class "bigtext" >> s sval >> span_

---------------------------
-- IMAGE
---------------------------
    a ! id "images" ! "/"
    div ! "images" >> do
	h3' "Demonstrate Simple Images"
	p
	s"This is a caption for the image."
	br
	img ! src "http://localhost/plumber.jpg" ! alt "plumber.jpg"
	    ! width "150" ! height  "180" ! title "Plumber" ! "/"
	br
	s"This should go under the image"

main = do
    --s <- readFile "jpd.hs"
    putStr $ def_http_hdr ++ render (def_html "Test Page" mystyle myhtml )

