
module Html_base (
    State (..)
    ,Html (..)
    ,q
    ,xhtml
    ,close
    ,render
    ,attr
    ,(!)
    ,(>>>)
) where

import Prelude hiding (div,id,span)
import Data.List hiding (span)

newtype State s a = State { runState :: s -> (a,s) }

instance Monad (State s) where
    return x = State $ \s -> (x,s)
    (State h) >>= f = State $ \s -> let (a, newState) = h s
					(State g) = f a
				    in g newState
execState m s = snd (runState m s)

data Html = Html {ztags :: [String], pcnt :: Int}

xhtml :: String -> State Html ()
xhtml s = State (\hd -> xhtml' s hd)
xhtml' s hd =
    let ztags' = ("<" ++ s ++ ">") : ztags hd
    in ((),hd{ztags=ztags'})

q :: String -> State Html ()
q s = State (\hd -> ((),hd {ztags=s:(ztags hd)}))

p_open :: State Html ()
p_open = State (\hd -> p_open' hd)
p_open' hd
    | (pcnt hd) > 0 = let ztags' = (etagit "p" ++ tagit "p") :ztags hd
		      in ((),hd{ztags=ztags'})
    | otherwise   = xhtml' "p" hd{pcnt=pcnt hd+1}

p_close = State (\hd -> p_close' hd)
p_close' hd = xhtml' "/p" hd{pcnt=pcnt hd-1}


close s = xhtml ('/':s)

{-
close1 :: String -> State Html ()
close1 sx = State (\hd -> ((),
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

x ! y = x >>= (\s-> atfunc0 y)
x >>> y = x >>= (\s->y)

atfunc0 :: String -> State Html ()
atfunc0 s = State ( \hd ->
    let hs = ztags hd
	hs' = ((init $ head hs) ++ " " ++ s ++ ">") : tail hs
	hd' = hd{ztags=hs'}
    in ((), hd')
  )

attr :: String -> String -> String
attr var val = var ++ ("=\"" ++ val ++  "\"")

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

