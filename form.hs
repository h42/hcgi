import Data.List
import System.Environment
import Html
import Html_def
import Prelude hiding (id,div,span)
import qualified Prelude as P


myhtml env = do
    h1 % "style=color:#008" >>> s"Html Form  Test Program" >>> h1_
    p
    form % method "query" % action "form"
    input % h_type "text" % name "input1" % value " " % size "20"
    form_
    p
    s env

--get_data env =

main = do
    env <- getEnvironment
    let envs = unlines $ map (\(x,y)->x ++ " = " ++ y ++ "<br />") env
    putStr $ def_http_hdr ++
	     render (def_html "Test Form" (s " ") (myhtml envs) )

