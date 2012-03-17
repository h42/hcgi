import Data.Char
import Html
import Html_def
import Prelude hiding (id,div,span)


--hexout r g b = "#" ++ hex r ++ hex g ++ hex b

--cellout r g b = "<td>" ++ hexout r g b ++ "</td>"

{-
hex x = sx where
    sx = [hexc (Prelude.div x 16), hexc (mod x 16) ]
    hexc x' | x'<10 = chr $ (ord '0') + x'
	    | otherwise = chr $ (ord 'A') + x' - 10
-}

--    print $ cellout 255 0 0 ++ cellout 255 255 0 ++ cellout 255 0 255

myhtml = do
    h1 >>> s"Color Test Program" >>> h1_

main = do
    putStr $ def_http_hdr ++ render (def_html "Test Color" (s " ") myhtml )

