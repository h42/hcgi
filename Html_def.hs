module Html_def (
    def_xmlns
    ,def_doctype
    ,def_http_hdr
    ,def_html
) where

import Html_base
import Html

-- DEFAULTS
def_http_hdr :: String
def_http_hdr = "Content-type: " ++ "text/html" ++ "; charset=utf-8\n\n"

def_xmlns = "http://www.w3.org/1999/xhtml"
def_doctype = xhtml
     "!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\""

def_html :: String -> State Html () -> State Html ()
def_html mytitle mysub = do
    def_doctype
    html ! xmlns def_xmlns

    h_head
    meta ! attr "http-equiv" "Content-Type"  ! attr "content" "text/html;charset=utf-8"  !  "/"
    h_title >>> q mytitle >>> h_title_
    h_head_

    body
    mysub
    body_
    html_

