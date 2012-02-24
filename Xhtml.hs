module Xhtml (
    Html (..)
    ,cgiPage
    ,attr
    ,(!)
    ,(>>>)

    ,body,body'
    ,br'
    ,div,div'
    ,h1,h1'
    ,h_head,h_head'
    ,html,html'
    ,meta
    ,p,p'
    ,q
    ,title,title'

    -- ATTRIBUTES
    ,hclass
    ,id
    ,xmlns

    -- Constants
    ,defDns
    ,defDoctype
) where

import Prelude hiding (id,div)
import Data.List
import Control.Monad.State

data Html = Html {ztags :: [String], junk :: String}

xhtml :: String -> State Html ()
xhtml s = state (\hd -> ( (), hd{ztags=("<" ++ s ++ ">"):(ztags hd)}  ))

q :: String -> State Html ()
q s = state (\hd -> ((),hd {ztags=s:(ztags hd)}))

x ! y = x >>= (\s-> atfunc0 y)
x >>> y = x >>= (\s->y)

atfunc0 :: String -> State Html ()
atfunc0 s = state ( \hd ->
    let hs = ztags hd
	hs' = ((init $ head hs) ++ " " ++ s ++ ">") : tail hs
	hd' = hd{ztags=hs'}
    in ((), hd')
  )

attr :: String -> String -> String
attr var val = var ++ ("=\"" ++ val ++  "\"")

body = xhtml "body"
body' = xhtml "/body"
br' = xhtml "br /"
div = xhtml "div"
div' = xhtml "/div"
h_head = xhtml "head"
h_head' = xhtml "/head"
html = xhtml "html"
html' = xhtml "/html"
h1 = xhtml "h1"
h1' = xhtml "/h1"
h2 = xhtml "h1"
h2' = xhtml "/h1"
h3 = xhtml "h1"
h3' = xhtml "/h1"
meta = xhtml "meta"
p = xhtml "p"
p' = xhtml "/p"
title = xhtml "title"
title' = xhtml "/title"

id val = attr "id" val
hclass val = attr "class" val
xmlns val = attr "xmlns" val


html0 :: Html -- KEEP for accurate error messages if Html changed
html0 = Html [] ""

html00 =
     Html [
     "</head>"
     ,"<title>" ++ "title" ++ "</title>"
     ,"<meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\" />"
     ,"<head>"
     ,"<html xmlns=\"http://www.w3.org/1999/xhtml\">"
     ,"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">"
    ] ""

defDns = "http://www.w3.org/1999/xhtml"
defDoctype = xhtml
     "!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\""

render :: State Html () -> String
render (hf) = s where
    hd = execState hf (html0)
    hs = reverse (ztags hd)
    s = foldr f "" hs
    f xx a = xx ++ ('\n':a)

cgiContent sx = "Content-type: " ++ sx ++ "; charset=utf-8\n\n"
cgiCookie sx = sx

cgiPage mytype cookie myhtml = hs where
    hs = cgiContent mytype ++ cgiCookie cookie ++ render myhtml

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

