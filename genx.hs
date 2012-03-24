import Data.List
import System.IO

tags = [
     "a"
    ,"abbr"
    ,"b"
    ,"blockquote"
    ,"body"
    ,"del"
    ,"div"
    ,"form"
    ,"h_head"
    ,"html"
    ,"h1","h2","h3","h4","h5","h6"
    ,"hr" -- horizontal rule  --  attrs deprecated
    ,"i"
    ,"img"
    ,"input"
    ,"ins"
    ,"li"
    ,"meta"
    ,"ol"
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
    ,"ul"
 ]

xetags = [
    "br"
 ]

stags = [
    "b"
    ,"h1","h2","h3","h4","h5","h6"
    ,"i"
    ,"q"
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

  where fstr f = f  ++  "  = btag "  ++ (show.fix) f  ++  "\n"
	      ++ f  ++  "_ = etag "  ++ (show.fix) f  ++  "\n"
	estr f = f  ++  " = btag \""  ++  fix f  ++  " /\"\n"
	astr f = f  ++  " val = atag "  ++  (show.fix) f  ++  " val\n"
	sstr f = f  ++  "' sx  = do\n"
	    ++ "    btag \""  ++  f  ++  "\"\n"
	    ++ "    s sx\n"
	    ++ "    etag \""  ++  f  ++  "\"\n"

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
