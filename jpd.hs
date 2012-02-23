module Main (
    main
    ,render
) where

import Data.List
import Control.Monad.State

data Html = Html {zhs :: [String], zid2 :: String}

xhtml :: String -> State Html ()
xhtml s = state (\hd -> ( (), hd{zhs=("<" ++ s ++ ">"):(zhs hd)}  ))

q :: String -> State Html ()
q s = state (\hd -> ((),hd {zhs=s:(zhs hd)}))

x ! y = x >>= (\s-> atfunc y)

atfunc :: String -> State Html ()
atfunc s = state (\hd -> ((),
     hd{zhs=( (init $ head (zhs hd)) ++ " " ++ s ++ ">"):(zhs hd)} ))

at1 n = "pos_x=\"" ++ (show n) ++ "\""
at2 n = "pos_y=\"" ++ (show n) ++ "\""

html = xhtml "html"
_html = xhtml "/html"
body = xhtml "body"
_body = xhtml "/body"
p = xhtml "p"
_p = xhtml "/p"
h1 = xhtml "h1"
_h1 = xhtml "/h1"

html00 title =
     Html [
     "</head>"
     ,"<title>" ++ title ++ "</title>"
     ,"<meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\" />"
     ,"<head>"
     ,"<html xmlns=\"http://www.w3.org/1999/xhtml\">"
     ,"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">"
    ] ""

render :: State Html () -> String -> String
render (hf) title = s where
    Html hs' id2 = execState hf (html00 title)
    hs = reverse $  "</html>" : hs'
    s = foldr f "" hs
    f xx a = xx ++ ('\n':a)


myhtml :: State Html ()
myhtml = do
    body
    myhtml_sub
    _body

myhtml_sub = do
    p ! at1 3 ! at2 5
    q "this is paragraph 1."
    h1
    do
      q "q data"
      q "q data"
    _h1
    q "this is paragraph 1a"
    _p
    p
    q "this is paragraph 2"
    _p

main = do
    putStrLn "Content-type: text/html; charset=utf-8\n"
    putStrLn $ render myhtml "junky"

