module Cgi (
    CGI (..)
    ,cgi_init
    ,cgi_var
    ,cgi_evar
) where

import System.Environment

-------------------------------
-- GETDATA
-------------------------------

type Vtab = [(String,String)]

data CGI = CGI {zenv :: Vtab, zvtab :: Vtab}
    deriving (Show)

-- CGI_INIT
cgi_init :: IO CGI
cgi_init = do
    env' <- getEnvironment
    vtab' <- case (cgi_lookup "REQUEST_METHOD" env') of
	"POST" -> fmap getdata getContents
	"GET"  -> return (getdata $ cgi_lookup "QUERY_STRING" env')
	_      -> return []
    return CGI {zenv=env', zvtab=vtab'}

-- CGI_VAR
cgi_var :: String -> CGI -> String
cgi_var v cgi = cgi_lookup v (zvtab cgi)

-- CGI_EVAR
cgi_evar :: String -> CGI -> String
cgi_evar v cgi = cgi_lookup v (zenv cgi)

-- CGI_LOOKUP
cgi_lookup v e = case (lookup v e) of
    Just x -> x
    Nothing -> []

-- GETDATA
getdata :: String -> Vtab
getdata xs = getdata2 xs "" "" []

getdata2 [] _ _ vt = vt
getdata2 ('=':xs) n v vt = getdata3 xs n "" vt
getdata2 (x:xs) n v vt = getdata2 xs (x:n) "" vt

getdata3 ('&':xs) n v vt = getdata2 xs "" "" ((reverse n,reverse v):vt)
getdata3 [] n v vt = getdata2 [] "" "" ((reverse n,reverse v):vt)
getdata3 (x:xs) n v vt = getdata3 xs n (x:v) vt

