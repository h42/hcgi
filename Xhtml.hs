module Xhtml (
    Html (..)
    ,render
    ,attr
    ,(!)
    ,(>>>)

    ,body,body_
    ,br
    ,div,div_
    ,h1,h1_
    ,h_head,h_head_
    ,html,html_
    ,meta
    ,p,p_
    ,q
    ,span,span_
    ,h_title,h_title_

    -- ATTRIBUTES
    ,hclass
    ,id
    ,title
    ,xmlns

    -- Constants
    ,def_xmlns
    ,def_doctype
    ,def_http_hdr
    ,def_html
) where

import Prelude hiding (div,id,span)
import Data.List hiding (span)
import Control.Monad.State

data Html = Html {ztags :: [String], pcnt :: Int}

xhtml :: String -> State Html ()
xhtml s = state (\hd -> xhtml' s hd)
xhtml' s hd =
    let ztags' = ("<" ++ s ++ ">") : ztags hd
    in ((),hd{ztags=ztags'})

p_open :: State Html ()
p_open = state (\hd -> p_open' hd)
p_open' hd
    | (pcnt hd) > 0 = let ztags' = (etagit "p" ++ tagit "p") :ztags hd
		      in ((),hd{ztags=ztags'})
    | otherwise   = xhtml' "p" hd{pcnt=pcnt hd+1}

p_close = state (\hd -> p_close' hd)
p_close' hd = xhtml' "/p" hd{pcnt=pcnt hd-1}


close s = xhtml ('/':s)

{-
close1 :: String -> State Html ()
close1 sx = state (\hd -> ( (),
    let (bt,et) = close2 sx (ztags hd) (etags hd)
    in hd{ztags=bt, etags=et}
 ))

close2 :: String -> [String] -> [String] -> ([String],[String])
close2 s tags []  = (tags,[])
close2 s (e:es) tags
    | s == e    = ((etagit s):tags,es)
    | otherwise = close2 s es (etagit s:tags)
-}

etagit :: String -> String
etagit s = "</" ++ s ++ ">"
tagit :: String -> String
tagit s = "<" ++ s ++ ">"


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
body_ = close "body"
br = xhtml "br /"
div = xhtml "div"
div_ = close "div"
h_head = xhtml "head"
h_head_ = close "head"
html = xhtml "html"
html_ = close "html"
h1 = xhtml "h1"
h1_ = close "h1"
h2 = xhtml "h1"
h2_ = close "h1"
h3 = xhtml "h1"
h3_ = close "h1"
meta = xhtml "meta"
p = xhtml "p"
p_ = close "p"
span = xhtml "span"
span_ = close "span"
h_title = xhtml "title"
h_title_ = close "title"

hclass val = attr "class" val
id val = attr "id" val
title val = attr "title" val
xmlns val = attr "xmlns" val


html0 :: Html -- KEEP for accurate error messages if Html changed
html0 = Html [] 0

render :: State Html () -> String
render (hf) = s where
    hd = execState hf (html0)
    hs = reverse (ztags hd)
    s = foldr f "" hs
    f xx a = xx ++ ('\n':a)

-- DEFAULTS
def_http_hdr :: String
def_http_hdr = "Content-type: " ++ "text/html" ++ "; charset=utf-8\n\n"

def_xmlns = "http://www.w3.org/1999/xhtml"
def_doctype = xhtml
     "!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\""

def_html :: String -> State Html () -> State Html ()
def_html mytitle mysub = do
    def_doctype
    html ! xmlns def_xmlns

    h_head
    meta ! attr "http-equiv" "Content-Type"  ! attr "content" "text/html;charset=utf-8"  !  "/"
    h_title >>> q mytitle >>> h_title_
    h_head_

    body
    mysub
    body_
    html_

