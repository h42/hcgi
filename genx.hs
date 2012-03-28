import Data.List
import System.IO

tags = [
     ("a","0")
    ,("abbr","1")
    ,("b","1")
    ,("blockquote","1")
    ,("body","1")
    ,("del","1")
    ,("div","7")
    ,("form","1")
    ,("h_head","1")
    ,("html","1")
    ,("h1","1"),("h2","1"),("h3","1"),("h4","1"),("h5","1"),("h6","1")
    ,("hr","0") -- horizontal rule  --  attrs deprecated
    ,("i","1")
    ,("img","0")
    ,("input","0")
    ,("ins","1")
    ,("li","7")
    ,("meta","0")
    ,("ol","1")
    ,("p","7")
    ,("pre","1")
    ,("q","1")
    ,("small","1")
    ,("span","1")
    ,("style","1")
    ,("sub","1")
    ,("super","1")
    ,("table","1")
    ,("td","7")
    ,("tr","7")
    ,("h_title","1")
    ,("ul","1")
 ]

xetags = [
    "br"
 ]

stags = [
    "b"
    ,"h1","h2","h3","h4","h5","h6"
    ,"i"
    ,"q"
    ,"small"
    ,"sub"
    ,"super"
  ]

--
-- Note - functions for attrs are not necessary for literals such as
--   "/" used to close tags with attrs like <img>
--
attrs = [
    "h_class","id","title","xmlns"
    ,"http_equiv"

    ,"accesskey"
    ,"action"
    ,"align"
    ,"alt"
    ,"border"
    ,"cite"
    ,"content"
    ,"height"
    ,"href"
    ,"maxlength"
    ,"method"
    ,"name"
    ,"width"
    ,"size"
    ,"src"
    ,"start"
    ,"tabindex"
    ,"h_type"
    ,"value"
 ]

exports = [
     "s"
    ,"(#)"
    ,"btag"
    ,"State"
    ,"Html"
    ,"render"
 ]

gen_mod =
    "--\n"
    ++ "-- PROGRAM IS GENERATED - DO NOT ALTER BY HAND\n"
    ++ "--\n\n"
    ++ "module Html (\n"
    ++  "    " ++ drop 5 (concatMap (\(t,_)-> "    ," ++ t ++  ',':t ++ "_\n") tags)
    ++  "\n"
    ++  (concatMap (\t-> "    ," ++ t ++ "\n") xetags)
    ++  "\n"
    ++  (concatMap (\t-> "    ," ++ t ++ "'\n") stags)
    ++  "\n"
    ++  (concatMap (\t-> "    ," ++ t ++ "\n") attrs)
    ++  "\n"
    ++  (concatMap (\t-> "    ," ++ t ++ "\n") exports)
    ++  ") where\n"

gen_funcs =
    "\n------ Functions --------------\n"
    ++  concatMap fstr tags
    ++ "\n"
    ++ concatMap estr xetags
    ++ "\n"
    ++  concatMap sstr stags
    ++ "\n"
    ++  concatMap astr attrs

  where fstr (f,pri) = concat[f," = btag ", (show.fix) f, " ", pri, "\n",
			      f,"_ = etag ", (show.fix) f, " ", pri, "\n"]
	estr f = concat [f, " = btag \"", fix f, " /\" 0\n"]
	astr f = f  ++  " val = atag "  ++  (show.fix) f  ++  " val\n"
	sstr f = f  ++  "' sx  = do\n"
	    ++ "    btag \""  ++  f  ++  "\" 0\n"
	    ++ "    s sx\n"
	    ++ "    etag \""  ++  f  ++  "\" 0\n"

	fix ('h' : '_' : xs) = xs
	fix xs = xs

gen_imports =
    "\n"
    ++ "import Html_base\n"
    ++ "import Prelude hiding (div,id,span)\n"
    ++ "import Data.List hiding (span)\n"


genx = gen_mod ++ gen_imports ++ gen_funcs

main = do
    hPutStrLn stderr "Genx running ..."
    putStr genx
