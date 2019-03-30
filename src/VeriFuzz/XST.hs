{-|
Module      : VeriFuzz.XST
Description : Xst (ise) simulator implementation.
Copyright   : (c) 2018-2019, Yann Herklotz
License     : BSD-3
Maintainer  : ymherklotz [at] gmail [dot] com
Stability   : experimental
Portability : POSIX

Xst (ise) simulator implementation.
-}

{-# LANGUAGE QuasiQuotes #-}

module VeriFuzz.XST where

import           Prelude               hiding (FilePath)
import           Shelly
import           Text.Shakespeare.Text (st)
import           VeriFuzz.CodeGen
import           VeriFuzz.Internal

data Xst = Xst { xstPath    :: {-# UNPACK #-} !FilePath
               , netgenPath :: {-# UNPACK #-} !FilePath
               }
           deriving (Eq, Show)

instance Tool Xst where
  toText _ = "xst"

instance Synthesisor Xst where
  runSynth = runSynthXst

defaultXst :: Xst
defaultXst = Xst "xst" "netgen"

runSynthXst :: Xst -> SourceInfo -> FilePath -> Sh ()
runSynthXst sim (SourceInfo top src) outf = do
    dir <- pwd
    writefile xstFile $ xstSynthConfig top
    writefile prjFile [st|verilog work "rtl.v"|]
    writefile "rtl.v" $ genSource src
    echoP "XST: run"
    _ <- logger dir "xst" $ timeout (xstPath sim) ["-ifn", toTextIgnore xstFile]
    echoP "XST: netgen"
    _ <- logger dir "netgen" $ run
        (netgenPath sim)
        [ "-w"
        , "-ofmt"
        , "verilog"
        , toTextIgnore $ modFile <.> "ngc"
        , toTextIgnore outf
        ]
    echoP "XST: clean"
    noPrint $ run_
        "sed"
        [ "-i"
        , "/^`ifndef/,/^`endif/ d; s/ *Timestamp: .*//;"
        , toTextIgnore outf
        ]
    echoP "XST: done"
  where
    modFile = fromText top
    xstFile = modFile <.> "xst"
    prjFile = modFile <.> "prj"
