import Data.List
import System.IO

tags = [
     "b"
    ,"big"
    ,"body"
    ,"div"
    ,"h_head"
    ,"html"
    ,"h1","h2","h3","h4","h5","h6"
    ,"i"
    ,"meta"
    ,"p"
    ,"pre"
    ,"small"
    ,"span"
    ,"h_title"
 ]

etags = [
    "br"
 ]

attrs = [
    "hclass","id","title","xmlns"
 ]

exports = [
    "def_html"
    ,"def_http_hdr"
 ]

gen_mod =
    "module Xhtml4 (\n"
    ++  "    " ++ drop 5 (concatMap (\t-> "    ," ++ t ++  ',':t ++ "_\n") tags)
    ++  "\n"
    ++  (concatMap (\t-> "    ," ++ t ++ "\n") etags)
    ++  "\n"
    ++  (concatMap (\t-> "    ," ++ t ++ "\n") attrs)
    ++  ") where\n"

gen_funcs =
    "\n------ Functions --------------\n"
    ++  concatMap fstr tags
    ++ "\n"
    ++ concatMap estr etags
    ++ "\n"
    ++  concatMap astr attrs
  where fstr f = f ++ "  = xhtml " ++ show f ++ "\n"
	      ++ f ++ "_ = close " ++ show f ++ "\n"
	estr f = f  ++  " = xhtml \""  ++  f  ++  "/\"\n"
	astr f = f ++ " val = attr " ++ show f ++ " val\n"

gen_imports =
    "\n"
    ++ "import Html_base\n"
    ++ "import Prelude hiding (div,id,span)\n"
    ++ "import Data.List hiding (span)\n"


genx = gen_mod ++ gen_imports ++ gen_funcs

main = do
    hPutStrLn stderr "Genx running ..."
    putStr genx
