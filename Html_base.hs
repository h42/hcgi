
module Html_base (
    State (..)
    ,Html (..)
    ,s
    ,btag
    ,etag
    ,render
    ,atag
    ,(%)
    ,(>>>)
) where

import Prelude hiding (div,id,span)
import Data.List hiding (span)

newtype State s a = State { runState :: s -> (a,s) }

instance Monad (State st) where
    return x = State $ \st -> (x,st)
    (State h) >>= f = State $ \st -> let (a, newState) = h st
					 (State g) = f a
				     in g newState
execState m st = snd (runState m st)

data Html = Html {ztags :: [String], pcnt :: Int}

btag :: String -> State Html ()
btag t = State (\hd -> btag' t hd)
btag' t hd =
    let ztags' = ("<" ++ t ++ ">") : ztags hd
    in ((),hd{ztags=ztags'})

s :: String -> State Html ()
s x = State (\hd -> ((),hd {ztags=x:(ztags hd)}))

p_open :: State Html ()
p_open = State (\hd -> p_open' hd)
p_open' hd
    | (pcnt hd) > 0 = let ztags' = (etagit "p" ++ tagit "p") :ztags hd
		      in ((),hd{ztags=ztags'})
    | otherwise   = btag' "p" hd{pcnt=pcnt hd+1}

p_etag = State (\hd -> p_etag' hd)
p_etag' hd = btag' "/p" hd{pcnt=pcnt hd-1}


etag t = btag ('/':t)

{-
etag1 :: String -> State Html ()
etag1 sx = State (\hd -> ((),
    let (bt,et) = etag2 sx (ztags hd) (etags hd)
    in hd{ztags=bt, etags=et}
 ))

etag2 :: String -> [String] -> [String] -> ([String],[String])
etag2 s tags []  = (tags,[])
etag2 s (e:es) tags
    | s == e    = ((etagit s):tags,es)
    | otherwise = etag2 s es (etagit s:tags)
-}

etagit :: String -> String
etagit t = "</" ++ t ++ ">"

tagit :: String -> String
tagit t = "<" ++ t ++ ">"

x % y = x >>= (\st -> atfunc0 y)
x >>> y = x >>= (\st -> y)

atfunc0 :: String -> State Html ()
atfunc0 st = State ( \hd ->
    let hs = ztags hd
	hs' = ((init $ head hs) ++ " " ++ st ++ ">") : tail hs
	hd' = hd{ztags=hs'}
    in ((), hd')
  )

atag :: String -> String -> String
atag var val = var ++ ("=\"" ++ val ++  "\"")

html0 :: Html -- KEEP for accurate error messages if Html changed
html0 = Html [] 0

render :: State Html () -> String
render (hf) = str where
    hd = execState hf (html0)
    hs = reverse (ztags hd)
    str = foldr f "" hs
    f xx a = xx ++ ('\n':a)

