
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
		 ,zerror :: Int
		 } deriving Show

errtag t t2 hd = "<!-- ERROR\n"
    ++ concat ["t=",t,"  t2=",t2,"\n"]
    ++ show (take 10 $ ztags hd) ++ "\n"
    ++ show (zetags hd) ++ "\n"
    ++ "-->"

---------------------
-- BTAG
---------------------
btag :: String -> Int -> State Html ()
btag t pri = State (\hd -> btag' t (if zerror hd == 1 then 0 else pri) hd)

btag' t 0 hd = ((), hd{ztags=tagit t : ztags hd})
btag' t p hd@(Html tags [] _ ) = ((),hd{ztags=tagit t : tags, zetags=[(t,p)]})

btag' t p hd@(Html tags etags@((t2,p2):es) err)
    | p==7 && t==t2 = ( (), hd{ztags=tagit t:etagit t:tags} )
    | p==7 && p2==7 && chk7 t es =
	btag' t p hd{ztags=etagit t2:tags,zetags=es}
    | otherwise     = ( (), hd{ztags=tagit t:tags, zetags=(t,p):etags})

chk7 t [] = False
chk7 t ((t2,p2):etags)
    | t2 == t = True
    | p2 == 7 = chk7 t etags
    | otherwise = False

---------------------
-- ETAG
---------------------
etag :: String -> Int -> State Html ()
etag t pri = State (\hd -> etag' t (if zerror hd /=0 then 0 else pri) hd)

etag' t 0 hd = ((),hd{ztags=(etagit t) : ztags hd})
etag' t p hd@(Html tags [] _) = ((),hd{ztags=etagit t:tags,zerror=1}) -- error state

etag' t p hd@(Html tags ((t2,p2):es) _)
    | t==t2     = ((),hd{ztags=etagit t:tags, zetags=es})
    | p2==7    = etag' t p hd{ztags=etagit t2:tags, zetags=es}
    | otherwise = ((),hd{ztags=errtag t t2 hd:etagit t:tags, zerror=1}) -- error state

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
html0 = Html [] [] 0

render :: State Html () -> String
render (hf) = str where
    hd = execState hf (html0)
    hs = reverse (ztags hd)
    str = foldr f "" hs  ++ show (zetags hd)
    f xx a = xx ++ ('\n':a)

