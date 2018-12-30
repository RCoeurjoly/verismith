{-|
Module      : Test.VeriFuzz.Verilog.Helpers
Description : Defaults and common functions.
Copyright   : (c) 2018-2019, Yann Herklotz Grave
License     : BSD-3
Maintainer  : ymherklotz [at] gmail [dot] com
Stability   : experimental
Portability : POSIX

Defaults and common functions.
-}

module Test.VeriFuzz.Verilog.Helpers where

import           Control.Lens
import           Data.Text                 (Text)
import qualified Data.Text
import           Test.VeriFuzz.Verilog.AST

regDecl :: Identifier -> ModItem
regDecl = Decl . Port (Reg False) 1

wireDecl :: Identifier -> ModItem
wireDecl = Decl . Port (PortNet Wire) 1

modConn :: Text -> ModConn
modConn = ModConn . PrimExpr . PrimId . Identifier

-- | Create a number expression which will be stored in a primary expression.
numExpr :: Int -> Int -> Expression
numExpr = ((PrimExpr . PrimNum) .) . Number

-- | Create an empty module.
emptyMod :: ModDecl
emptyMod = ModDecl "" [] [] []

-- | Set a module name for a module declaration.
setModName :: Text -> ModDecl -> ModDecl
setModName str = moduleId .~ Identifier str

-- | Add a input port to the module declaration.
addModPort :: Port -> ModDecl -> ModDecl
addModPort port = modInPorts %~ (:) port

addDescription :: Description -> VerilogSrc -> VerilogSrc
addDescription desc = getVerilogSrc %~ (:) desc

testBench :: ModDecl
testBench =
  ModDecl "main" [] []
  [ regDecl "a"
  , regDecl "b"
  , wireDecl "c"
  , ModInst "and" "and_gate"
    [ modConn "c"
    , modConn "a"
    , modConn "b"
    ]
  , Initial $ SeqBlock
    [ BlockAssign . Assign (RegId "a") Nothing . PrimExpr . PrimNum $ Number 1 1
    , BlockAssign . Assign (RegId "b") Nothing . PrimExpr . PrimNum $ Number 1 1
    -- , TimeCtrl (Delay 1) . Just . SysTaskEnable $ Task "display"
    --   [ ExprStr "%d & %d = %d"
    --   , PrimExpr $ PrimId "a"
    --   , PrimExpr $ PrimId "b"
    --   , PrimExpr $ PrimId "c"
    --   ]
    -- , SysTaskEnable $ Task "finish" []
    ]
  ]

addTestBench :: VerilogSrc -> VerilogSrc
addTestBench = addDescription $ Description testBench

defaultPort :: Identifier -> Port
defaultPort = Port (PortNet Wire) 1