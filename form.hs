import Data.List
import System.Environment
import Html
import Html_def
import Cgi
import Prelude hiding (id,div,span)
import qualified Prelude as P

-- textInput
input_text nm len val =
     input ! h_type "text" ! name nm ! value val ! size (show len)
input_vtext nm len cgi = input_text nm len (cgi_var nm cgi)

--
-- Application
--

myhtml cgi = do
    h1 ! "style=color:#008" >> s"Html Form  Test Program" >> h1_
    p
    --form ! method "query" ! action "form"
    form ! method "post" ! action "form"
    input_vtext "input1" 20 cgi ! id "t1"
    br
    input_text "input2" 20 "b12345"
    br
    input ! h_type "submit" ! name "sub1" ! value "sub1val"
    br
    input ! h_type "submit" ! name "sub2" ! value "sub2val"
    form_
    p_
    s (show (zvtab cgi)) >> br
    s (unlines $ map (\(x,y)->x ++ " = " ++ y ++ "<br />") (zenv cgi)) >> br

main = do
    cgi <- cgi_init
    print cgi
    putStr $ def_http_hdr ++
	     render (def_html "Test Form" (s " ") (myhtml cgi) )

