import Control.Monad.State
import Xhtml

myhtml :: State Html ()
myhtml = do
    body
    myhtml_sub
    _body

myhtml_sub = do
    p ! at1 3 ! at2 5
    q "this is paragraph 1."
    do
      h1
      q "q data"
      q "q data"
      _h1
    q "this is paragraph 1a"
    _p
    p
    q "this is paragraph 2"
    _p

main = do
    putStr $ cgiPage "text/html" "cookie" myhtml "Test Page"

