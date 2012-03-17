module Html_def (
    def_xmlns
    ,def_doctype
    ,def_http_hdr
    ,def_html
) where

--import Html_base
import Html

-- DEFAULTS
def_http_hdr :: String
def_http_hdr = "Content-type: " ++ "text/html" ++ "; charset=utf-8\n\n"

def_xmlns = "http://www.w3.org/1999/xhtml"
def_doctype = btag
     "!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\""

def_html :: String -> State Html () -> State Html () -> State Html ()
def_html mytitle mystyle mybody = do
    def_doctype
    html % xmlns def_xmlns

    h_head
    meta % http_equiv "Content-Type"  % content "text/html;charset=utf-8"  %  "/"
    h_title >>> s  mytitle >>> h_title_
    mystyle
    h_head_

    body
    mybody
    body_
    html_

