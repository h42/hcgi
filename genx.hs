import Data.List
import System.IO

tags = [
     "a"
    ,"abbr"
    ,"acronym"
    ,"b"
    ,"big"
    ,"blockquote"
    ,"body"
    ,"center"
    ,"del"
    ,"div"
    ,"h_head"
    ,"html"
    ,"h1","h2","h3","h4","h5","h6"
    ,"hr" -- horizontal rule  --  attrs deprecated
    ,"i"
    ,"img"
    ,"ins"
    ,"meta"
    ,"p"
    ,"pre"
    ,"q"
    ,"small"
    ,"span"
    ,"style"
    ,"sub"
    ,"super"
    ,"table"
    ,"td"
    ,"tr"
    ,"h_title"
 ]

etags = [
    "br"
 ]

--
-- Note - functions for attrs are not necessary for literals such as
--   "/" used to close tags with attrs like <img>
--
attrs = [
    "h_class","id","title","xmlns"
    ,"http_equiv"

    ,"accesskey"
    ,"align"
    ,"alt"
    ,"border"
    ,"cite"
    ,"content"
    ,"height"
    ,"href"
    ,"name"
    ,"width"
    ,"src"
    ,"tabindex"
    ,"h_type"
 ]

exports = [
     "s"
    ,"(%)"
    ,"(>>>)"
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
    ++  "    " ++ drop 5 (concatMap (\t-> "    ," ++ t ++  ',':t ++ "_\n") tags)
    ++  "\n"
    ++  (concatMap (\t-> "    ," ++ t ++ "\n") etags)
    ++  "\n"
    ++  (concatMap (\t-> "    ," ++ t ++ "\n") attrs)
    ++  "\n"
    ++  (concatMap (\t-> "    ," ++ t ++ "\n") exports)
    ++  ") where\n"

gen_funcs =
    "\n------ Functions --------------\n"
    ++  concatMap fstr tags
    ++ "\n"
    ++ concatMap estr etags
    ++ "\n"
    ++  concatMap astr attrs
  where fstr f = f  ++  "  = btag "  ++ (show.fix) f  ++  "\n"
	      ++ f  ++  "_ = etag "  ++ (show.fix) f  ++  "\n"
	estr f = f  ++  " = btag \""  ++  fix f  ++  " /\"\n"
	astr f = f  ++  " val = atag "  ++  (show.fix) f  ++  " val\n"

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
