
module Html_base (
    State (..)
    ,Html (..)
    ,s
    ,btag
    ,etag
    ,render
    ,atag
    ,(#)
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

data Html = Html {ztags :: [String]
		 ,zetags :: [(String,Int)]
		 }
---------------------
-- BTAG
---------------------
btag :: String -> Int -> State Html ()
btag t pri = State (\hd -> btag' t pri hd)

btag' t 0 hd = ((), hd{ztags=tagit t : ztags hd})
btag' t pri hd@(Html tags []) = ((),hd{ztags=tagit t : tags, zetags=[(t,pri)]})

btag' t pri hd@(Html tags etags@((t2,p2):es))
    | p2 > pri    = ((),hd{ztags=tagit t:tags, zetags=(t,pri):etags})
    | p2 < pri    = btag' t pri hd{ztags=etagit t2:tags, zetags=es}
    | p2 == pri   = ( (), hd{ztags=tagit t2:etagit t2:tags} )

---------------------
-- ETAG
---------------------
etag :: String -> Int -> State Html ()
etag t 0 = State (\hd -> etag0 t 0 hd)
etag t pri = State (\hd -> etag' t pri hd)

  -- NO AUTO CLOSE
etag0 t pri hd =
    let ztags' = (etagit t) : ztags hd
    in ((),hd{ztags=ztags'})

  -- AUTO CLOSE
etag' t pri hd@(Html tags []) = ((),hd) -- error state

etag' t p hd@(Html tags ((t2,p2):es))
    | p2 < p    = etag' t p hd{ztags=etagit t2:tags, zetags=es}
    | p2 == p   = ((),hd{ztags=etagit t2:tags, zetags=es})
     -- did ot find tag but add anyway ???
    | otherwise = ((),hd{ztags=etagit t:tags})

---------------------
-- SUBTAG
---------------------
subtag :: String -> String -> State Html ()
subtag t xs = State (\hd -> subtag' t xs hd)
subtag' t xs hd =
    let ztags' = (tagit t ++ xs ++ etagit t) : ztags hd
    in ((),hd{ztags=ztags'})


s :: String -> State Html ()
s x = State (\hd -> ((),hd {ztags=x:(ztags hd)}))

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

x # y = x >>= (\st -> atfunc0 y)

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
html0 = Html [] []

render :: State Html () -> String
render (hf) = str where
    hd = execState hf (html0)
    hs = reverse (ztags hd)
    str = foldr f "" hs  ++ show (zetags hd)
    f xx a = xx ++ ('\n':a)

