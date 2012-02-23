module Main (
    main
    ,render
) where

import Data.List
import Control.Monad.State

data Html = Html {ztags :: [String], junk :: String}

xhtml :: String -> State Html ()
xhtml s = state (\hd -> ( (), hd{ztags=("<" ++ s ++ ">"):(ztags hd)}  ))

q :: String -> State Html ()
q s = state (\hd -> ((),hd {ztags=s:(ztags hd)}))

x ! y = x >>= (\s-> atfunc y)

atfunc :: String -> State Html ()
atfunc s = state ( \hd ->
    let hs = ztags hd
	hs' = ((init $ head hs) ++ " " ++ s ++ ">") : hs
	hd' = hd{ztags=hs'}
    in ((), hd')
  )

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

html0 :: String -> Html -- KEEP for accurate error messages if Html changed
html0 title =
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
    hd = execState hf (html0 title)
    hs = reverse $  "</html>" : (ztags hd)
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
    do
      h1
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

