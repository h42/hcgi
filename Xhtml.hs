module Xhtml (
    Html (..)
    ,cgiPage
    ,(!)
    ,(>>>)

    ,body,body'
    ,br'
    ,div,div'
    ,h1,h1'
    ,html,html'
    ,p,p'
    ,q

    -- ATTRIBUTES
    ,hclass
    ,id
) where

import Prelude hiding (head,id,div)
import Data.List
import Control.Monad.State

data Html = Html {ztags :: [String], junk :: String}

xhtml :: String -> State Html ()
xhtml s = state (\hd -> ( (), hd{ztags=("<" ++ s ++ ">"):(ztags hd)}  ))

q :: String -> State Html ()
q s = state (\hd -> ((),hd {ztags=s:(ztags hd)}))

x ! y = x >>= (\s-> atfunc y)
x >>> y = x >>= (\s->y)

atfunc :: String -> State Html ()
atfunc s = state ( \hd ->
    let hs = ztags hd
	hs' = ((init $ head hs) ++ " " ++ s ++ ">") : tail hs
	hd' = hd{ztags=hs'}
    in ((), hd')
  )

atfunc2 :: String -> String -> String
atfunc2 attr val = attr ++ ("=\"" ++ val ++  "\"")

body = xhtml "body"
body' = xhtml "/body"
br' = xhtml "br /"
div = xhtml "div"
div' = xhtml "/div"
html = xhtml "html"
html' = xhtml "/html"
h1 = xhtml "h1"
h1' = xhtml "/h1"
h2 = xhtml "h1"
h2' = xhtml "/h1"
h3 = xhtml "h1"
h3' = xhtml "/h1"
p = xhtml "p"
p' = xhtml "/p"

id val = atfunc2 "id" val
hclass val = atfunc2 "class" val


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

cgiContent sx = "Content-type: " ++ sx ++ "; charset=utf-8\n\n"
cgiCookie sx = sx

cgiPage mytype cookie myhtml title = hs where
    hs = cgiContent mytype ++ cgiCookie cookie ++ render myhtml title

{-myhtml :: State Html ()
myhtml = do
    body
    myhtml_sub
    body'

myhtml_sub = do
    p ! at1 3 ! at2 5
    q "this is paragraph 1."
    do
      h1
      q "q data"
      q "q data"
      h1'
    q "this is paragraph 1a"
    p'
    p
    q "this is paragraph 2"
    p'
-}

