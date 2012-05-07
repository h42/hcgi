import Data.List
import System.Cmd
import System.Environment
import System.Directory

main = do
    let cmd fn = "convert -define jpeg:size=500x180 "
	    ++ ifn
	    ++ " -auto-orient -thumbnail 250x90 -unsharp 0x.5 "
	    ++ ofn
	  where
	    fnl = length fn
	    sufl =
		if (any ((flip isSuffixOf) fn) [".jpg",".JPG"] ) then 4 else 0
	    ifn = if sufl > 0 then fn else fn ++ ".jpg"
	    ofn = if sufl==0  then fn ++ ".th.gif"
		  else take (fnl-4) fn ++ ".th.gif"

    args <- getArgs
    case args of
	[fn] -> do
	    let s = cmd fn
	    print s
	    system $ cmd fn
	    return ()
	_ ->  putStrLn "Usage: mkthumb <Filename>"

