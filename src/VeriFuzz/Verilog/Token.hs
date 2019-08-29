{-|
Module      : VeriSmith.Verilog.Token
Description : Tokens for Verilog parsing.
Copyright   : (c) 2019, Yann Herklotz Grave
License     : GPL-3
Maintainer  : yann [at] yannherklotz [dot] com
Stability   : experimental
Portability : POSIX

Tokens for Verilog parsing.
-}

module VeriSmith.Verilog.Token
    ( Token(..)
    , TokenName(..)
    , Position(..)
    , tokenString
    )
where

import           Text.Printf

tokenString :: Token -> String
tokenString (Token _ s _) = s

data Position = Position String Int Int deriving Eq

instance Show Position where
  show (Position f l c) = printf "%s:%d:%d" f l c

data Token = Token TokenName String Position deriving (Show, Eq)

data TokenName
  = KWAlias
  | KWAlways
  | KWAlwaysComb
  | KWAlwaysFf
  | KWAlwaysLatch
  | KWAnd
  | KWAssert
  | KWAssign
  | KWAssume
  | KWAutomatic
  | KWBefore
  | KWBegin
  | KWBind
  | KWBins
  | KWBinsof
  | KWBit
  | KWBreak
  | KWBuf
  | KWBufif0
  | KWBufif1
  | KWByte
  | KWCase
  | KWCasex
  | KWCasez
  | KWCell
  | KWChandle
  | KWClass
  | KWClocking
  | KWCmos
  | KWConfig
  | KWConst
  | KWConstraint
  | KWContext
  | KWContinue
  | KWCover
  | KWCovergroup
  | KWCoverpoint
  | KWCross
  | KWDeassign
  | KWDefault
  | KWDefparam
  | KWDesign
  | KWDisable
  | KWDist
  | KWDo
  | KWEdge
  | KWElse
  | KWEnd
  | KWEndcase
  | KWEndclass
  | KWEndclocking
  | KWEndconfig
  | KWEndfunction
  | KWEndgenerate
  | KWEndgroup
  | KWEndinterface
  | KWEndmodule
  | KWEndpackage
  | KWEndprimitive
  | KWEndprogram
  | KWEndproperty
  | KWEndspecify
  | KWEndsequence
  | KWEndtable
  | KWEndtask
  | KWEnum
  | KWEvent
  | KWExpect
  | KWExport
  | KWExtends
  | KWExtern
  | KWFinal
  | KWFirstMatch
  | KWFor
  | KWForce
  | KWForeach
  | KWForever
  | KWFork
  | KWForkjoin
  | KWFunction
  | KWFunctionPrototype
  | KWGenerate
  | KWGenvar
  | KWHighz0
  | KWHighz1
  | KWIf
  | KWIff
  | KWIfnone
  | KWIgnoreBins
  | KWIllegalBins
  | KWImport
  | KWIncdir
  | KWInclude
  | KWInitial
  | KWInout
  | KWInput
  | KWInside
  | KWInstance
  | KWInt
  | KWInteger
  | KWInterface
  | KWIntersect
  | KWJoin
  | KWJoinAny
  | KWJoinNone
  | KWLarge
  | KWLiblist
  | KWLibrary
  | KWLocal
  | KWLocalparam
  | KWLogic
  | KWLongint
  | KWMacromodule
  | KWMatches
  | KWMedium
  | KWModport
  | KWModule
  | KWNand
  | KWNegedge
  | KWNew
  | KWNmos
  | KWNor
  | KWNoshowcancelled
  | KWNot
  | KWNotif0
  | KWNotif1
  | KWNull
  | KWOption
  | KWOr
  | KWOutput
  | KWPackage
  | KWPacked
  | KWParameter
  | KWPathpulseDollar
  | KWPmos
  | KWPosedge
  | KWPrimitive
  | KWPriority
  | KWProgram
  | KWProperty
  | KWProtected
  | KWPull0
  | KWPull1
  | KWPulldown
  | KWPullup
  | KWPulsestyleOnevent
  | KWPulsestyleOndetect
  | KWPure
  | KWRand
  | KWRandc
  | KWRandcase
  | KWRandsequence
  | KWRcmos
  | KWReal
  | KWRealtime
  | KWRef
  | KWReg
  | KWRelease
  | KWRepeat
  | KWReturn
  | KWRnmos
  | KWRpmos
  | KWRtran
  | KWRtranif0
  | KWRtranif1
  | KWScalared
  | KWSequence
  | KWShortint
  | KWShortreal
  | KWShowcancelled
  | KWSigned
  | KWSmall
  | KWSolve
  | KWSpecify
  | KWSpecparam
  | KWStatic
  | KWStrength0
  | KWStrength1
  | KWString
  | KWStrong0
  | KWStrong1
  | KWStruct
  | KWSuper
  | KWSupply0
  | KWSupply1
  | KWTable
  | KWTagged
  | KWTask
  | KWThis
  | KWThroughout
  | KWTime
  | KWTimeprecision
  | KWTimeunit
  | KWTran
  | KWTranif0
  | KWTranif1
  | KWTri
  | KWTri0
  | KWTri1
  | KWTriand
  | KWTrior
  | KWTrireg
  | KWType
  | KWTypedef
  | KWTypeOption
  | KWUnion
  | KWUnique
  | KWUnsigned
  | KWUse
  | KWVar
  | KWVectored
  | KWVirtual
  | KWVoid
  | KWWait
  | KWWaitOrder
  | KWWand
  | KWWeak0
  | KWWeak1
  | KWWhile
  | KWWildcard
  | KWWire
  | KWWith
  | KWWithin
  | KWWor
  | KWXnor
  | KWXor
  | IdSimple
  | IdEscaped
  | IdSystem
  | LitNumberUnsigned
  | LitNumber
  | LitString
  | SymParenL
  | SymParenR
  | SymBrackL
  | SymBrackR
  | SymBraceL
  | SymBraceR
  | SymTildy
  | SymBang
  | SymAt
  | SymPound
  | SymPercent
  | SymHat
  | SymAmp
  | SymBar
  | SymAster
  | SymDot
  | SymComma
  | SymColon
  | SymSemi
  | SymEq
  | SymLt
  | SymGt
  | SymPlus
  | SymDash
  | SymQuestion
  | SymSlash
  | SymDollar
  | SymSQuote
  | SymTildyAmp
  | SymTildyBar
  | SymTildyHat
  | SymHatTildy
  | SymEqEq
  | SymBangEq
  | SymAmpAmp
  | SymBarBar
  | SymAsterAster
  | SymLtEq
  | SymGtEq
  | SymGtGt
  | SymLtLt
  | SymPlusPlus
  | SymDashDash
  | SymPlusEq
  | SymDashEq
  | SymAsterEq
  | SymSlashEq
  | SymPercentEq
  | SymAmpEq
  | SymBarEq
  | SymHatEq
  | SymPlusColon
  | SymDashColon
  | SymColonColon
  | SymDotAster
  | SymDashGt
  | SymColonEq
  | SymColonSlash
  | SymPoundPound
  | SymBrackLAster
  | SymBrackLEq
  | SymEqGt
  | SymAtAster
  | SymParenLAster
  | SymAsterParenR
  | SymAsterGt
  | SymEqEqEq
  | SymBangEqEq
  | SymEqQuestionEq
  | SymBangQuestionEq
  | SymGtGtGt
  | SymLtLtLt
  | SymLtLtEq
  | SymGtGtEq
  | SymBarDashGt
  | SymBarEqGt
  | SymBrackLDashGt
  | SymAtAtParenL
  | SymParenLAsterParenR
  | SymDashGtGt
  | SymAmpAmpAmp
  | SymLtLtLtEq
  | SymGtGtGtEq
  | Unknown
  deriving (Show, Eq)
