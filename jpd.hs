import Html
import Html_def
import Prelude hiding (id,div,span)

mystyle = do
    style % h_type "text/css"

    s"body {background-color:#f8f8f8;color:green;}"

    s"h3 {color:blue}"
    s"img{border:4px solid red;}"

    s"div.bigsmall {color:navy}"
    s"div.bigsmall h3 {color:navy}"

    s"div#simple  {color:navy}"
    s"p.par1 {color:blue}"

    s"li {color:blue}"
    s"ol li {color:navy}"
    -- s"#table {color:aqua}"

    style_

myhtml = do
    h1
    s "HCGI Demo Program"
    h1_

---------------------------
-- Table of COntents
---------------------------
    div >>> do
	h3 >>> s"Table of Contents" >>> h3_
	p >>> blockquote

	a %href "#simple" >>> s"Simple Formatting" >>> a_
	br
	a %href "#preformatted" >>> s"Preformatted Text" >>> a_
	br
	a %href "#bigsmall" >>> s"Big / Small Text" >>> a_
	br
	a %href "#list" >>> s"List" >>> a_
	br
	a %href "#table" >>> s"Table" >>> a_
	br
	a %href "#images" >>> s"Images" >>> a_
	br

	a % href "http://stackoverflow.com/questions/tagged/haskell"
	  % accesskey "o" % tabindex "2"
	s "A link to " >>> b >>> s"stackoverflow" >>> b_
	a_ >>> br

	a % href "http://www.reddit.com/r/haskell/"
	  % accesskey "r" % tabindex "1"
	s "A link to " >>> b >>> s"reddit/r/haskell" >>> b_
	a_ >>> br

	a % href "http://http://ALG_3rd.pdf"
	s "A link to a" >>> b >>> s"PDF" >>> b_ >>> s"on my computer"
	a_ >>> br
	blockquote_ >>> p_
    div_

---------------------------
-- List
---------------------------
    a % name "list" % "/"
    div >>> do
	h3 >>> s"List Example" >>> h3_
	ul >> do
	p >>> li >>> do
	    s"This is a list item"
	    ol >>> do
		li >>> s"This is a list item"
		li >>> s"This is a list item"
		li >>> s"This is a list item"
	    ol_
	li_
	p >>> li >>> do
	    s"This is a list item"
	    ol >>> do
		li >>> s"This is a list item"
		li >>> s"This is a list item"
		li >>> s"This is a list item"
	    ol_
	li_
	p >>> li >>> do
	    s"This is a list item"
	    ol >>> do
		li >>> s"This is a list item"
		li >>> s"This is a list item"
		li >>> s"This is a list item"
	    ol_
	li_
	ul_
    div_

---------------------------
-- TABLE
---------------------------
    a % name "table" % "/"
    div % id "table" >>> do
	h3 >>> s"Table Example" >>> h3_
	table % "border=2" >>> do
	    tr >>> do
		td >>> s"table 1 1"
		td >>> s"table 1 2"
	    tr >>> do
		td >>> s"table 2 1"
		td >>> s"table 2 2"
	    tr_
	table_
    div_

---------------------------
-- Simple
---------------------------
    a % name "simple" % "/"
    div % id "simple" >>> do -- Simple formatting
	h3>>>s"Simple Formatting" >>>h3_
	p % h_class "par1"
	s "This is the first paragraph. we can" >>> b >>> s"bold" >>> b_
	s "things or" >>> i >>> s"italicize things." >>> i_
	br
	s "This sample program will eventually show a great many features"
	s "of html"

	span % h_class "span 1"
	br
	s"This sentence is enclosed in a span which we can format separately"
	br
	span_

	p
	mapM_ (\_ -> do
	    s "This sentence is just here to fill up space so we can test links better."
	    br) [1..20]

	p_
    div_

---------------------------
-- PRE
---------------------------
    a % name "preformatted" % "/"
    div >>> do -- Preformatted text
	h3 >>> s"Preformatted Text" >>> h3_
	p
	s"This paragraph will be used to demonstrate preformatted code."
	--br
	s"like this code snippet"
	pre
	mycode
	pre_
	p_
    div_

---------------------------
-- BIG/SMALL
---------------------------
    a % name "bigsmall" % "/"
    div % h_class "bigsmall" >>> do -- Big / Small
	h3  >>> s"Demonstrate big/small" >>> h3_
	small >>> s"this is small line 1." >>> small_
	br >>> s"Normal line 1"
	br >>> s"Normal line 2"
	br >>> s"Normal line 3"
	let sval = "this is big line 1"
	br >>> big >>> s sval >>> big_
    div_

---------------------------
-- IMAGE
---------------------------
    a % name "images" % "/"
    div >>> do
	h3 >>> s"Demonstrate Simple Images" >>> h3_
	p
	s"This is a caption for the image."
	br
	img % src "http://localhost/plumber.jpg" % alt "plumber.jpg"
	    % width "150" % height  "180" % title "Plumber" % "/"
	br
	s"This should go under the image"
	p_
    div_


mycode = do
    s "close2 :: String -> [String] -> [String] -> ([String],[String])"
    s "close2 s tags []  = (tags,[])"
    s "close2 s (e:es) tags"
    s "    | s == e    = ((etagit s):tags,es)"
    s "    | otherwise = close2 s es (etagit s:tags)"

main = do
    --s <- readFile "jpd.hs"
    putStr $ def_http_hdr ++ render (def_html "Test Page" mystyle myhtml )

