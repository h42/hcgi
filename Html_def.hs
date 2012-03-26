module Html_def (
     def_doctype
    ,def_http_hdr
    ,def_html
) where

--import Html_base
import Html

-- DEFAULTS
def_http_hdr :: String
def_http_hdr = "Content-type: " ++ "text/html" ++ "; charset=utf-8\n\n"

-- <html> attribute if you want to conform to XHTML
def_xmlns = "http://www.w3.org/1999/xhtml"
def_doctype = btag "!DOCTYPE HTML" 0

def_html :: String -> State Html () -> State Html () -> State Html ()
def_html mytitle mystyle mybody = do
    def_doctype
    html

    h_head
    meta # http_equiv "Content-Type"  # content "text/html;charset=utf-8"  #  "/"
    h_title >>> s  mytitle >>> h_title_
    mystyle
    h_head_

    body
    mybody
    body_
    html_

