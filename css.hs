import Data.Char
import Data.List
import Html
import Html_def
import Prelude hiding (id,div,span)
import qualified Prelude as P

mystyle = do
    style ! h_type "text/css"
    s"body {background-color:#f0f8f8;color:#0000c0;}"
    s"#leftcol {width:200px;}"
    s"#leftcol {position:absolute}"
    s"#maincol {width:800px}"
    s"#maincol {position:absolute;left:220px}"
    s"#rightcol {position:absolute;left:1040px}"
    style_

myhtml = do
    h1 ! "style=color:red" >> s"CSS Test Program" >> h1_

    let lw=5
	rw=5

    div ! id "leftcol" >> do
	p
	s $ concat $ replicate lw "This is data for the left column"
	p
	s $ concat $ replicate lw "This is data for the left column"
    div_

    div ! id "maincol" >> do
	p
	s $ concat (replicate 10 "This is data for the main column")
	p
	s $ concat $ replicate 10 "This is data for the main column"
    div_

    div ! id "rightcol" >> do
	p
	s $ concat $ replicate rw "This is data for the right column"
	p
	s $ concat $ replicate rw "This is data for the right column"
    div_

main = do
    putStr $ def_http_hdr ++ render (def_html "Test CSS" mystyle myhtml )

