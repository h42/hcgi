import Data.List
import System.Environment
import Html
import Html_def
import Prelude hiding (id,div,span)
import qualified Prelude as P

getdata :: String -> [(String,String)]
getdata xs = getdata2 xs "" "" []

getdata2 [] _ _ vt = vt
getdata2 ('=':xs) n v vt = getdata3 xs n "" vt
getdata2 (x:xs) n v vt = getdata2 xs (x:n) "" vt

getdata3 ('&':xs) n v vt = getdata2 xs "" "" ((reverse n,reverse v):vt)
getdata3 [] n v vt = getdata2 [] "" "" ((reverse n,reverse v):vt)
getdata3 (x:xs) n v vt = getdata3 xs n (x:v) vt

myhtml env = do
    h1 # "style=color:#008" >>> s"Html Form  Test Program" >>> h1_
    p
    form # method "query" # action "form"
    input # h_type "text" # name "input1" # value "a12345" # size "20"
    br
    input # h_type "text" # name "input2" # value "b12345" # size "20"
    br
    input # h_type "submit" # name "sub1" # value "sub1"
    br
    input # h_type "submit" # name "sub2" # value "sub2"
    form_
    p_
    s env

--get_data env =

main = do
    env <- getEnvironment
    let mq' = case (lookup "QUERY_STRING" env) of
		Nothing -> []
		Just xs -> getdata xs
	mq = show mq' ++ "<br />\n"
    let envs = unlines $ map (\(x,y)->x ++ " = " ++ y ++ "<br />") env
    putStr $ def_http_hdr ++
	     render (def_html "Test Form" (s " ") (myhtml $mq) ) -- ++ envs) )

