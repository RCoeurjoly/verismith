{-|
Module      : VeriFuzz.Config
Description : Configuration file format and parser.
Copyright   : (c) 2019, Yann Herklotz
License     : GPL-3
Maintainer  : ymherklotz [at] gmail [dot] com
Stability   : experimental
Portability : POSIX

Configuration file format and parser.
-}

{-# LANGUAGE TemplateHaskell #-}

module VeriFuzz.Config
    ( Config(..)
    , defaultConfig
    , Probability(..)
    , probBlock
    , probNonBlock
    , probAssign
    , probAlways
    , propSize
    , propSeed
    , configProbability
    , configProperty
    , parseConfigFile
    , parseConfig
    )
where

import           Control.Applicative (Alternative)
import           Control.Lens        hiding ((.=))
import           Data.Maybe          (fromMaybe)
import           Data.Text           (Text)
import           Toml                (TomlCodec, (.=))
import qualified Toml

data Probability = Probability { _probAssign   :: {-# UNPACK #-} !Int
                               , _probAlways   :: {-# UNPACK #-} !Int
                               , _probBlock    :: {-# UNPACK #-} !Int
                               , _probNonBlock :: {-# UNPACK #-} !Int
                               }
                 deriving (Eq, Show)

makeLenses ''Probability

data Property = Property { _propSize :: {-# UNPACK #-} !Int
                         , _propSeed :: !(Maybe Int)
                         }
              deriving (Eq, Show)

makeLenses ''Property

data Config = Config { _configProbability :: {-# UNPACK #-} !Probability
                     , _configProperty    :: {-# UNPACK #-} !Property
                     }
            deriving (Eq, Show)

makeLenses ''Config

defaultValue
    :: (Alternative r, Applicative w)
    => b
    -> Toml.Codec r w a b
    -> Toml.Codec r w a b
defaultValue x = Toml.dimap Just (fromMaybe x) . Toml.dioptional

defaultConfig :: Config
defaultConfig = Config (Probability 10 1 1 1) (Property 50 Nothing)

probCodec :: TomlCodec Probability
probCodec =
    Probability
        <$> defaultValue (defProb probAssign) (Toml.int "assign")
        .=  _probAssign
        <*> defaultValue (defProb probAlways) (Toml.int "always")
        .=  _probAlways
        <*> defaultValue (defProb probBlock) (Toml.int "blocking")
        .=  _probAlways
        <*> defaultValue (defProb probNonBlock) (Toml.int "nonblocking")
        .=  _probAlways
    where defProb i = defaultConfig ^. configProbability . i

propCodec :: TomlCodec Property
propCodec =
    Property
        <$> defaultValue (defProp propSize) (Toml.int "size")
        .=  _propSize
        <*> Toml.dioptional (Toml.int "seed")
        .=  _propSeed
    where defProp i = defaultConfig ^. configProperty . i

configCodec :: TomlCodec Config
configCodec =
    Config
        <$> defaultValue (defaultConfig ^. configProbability)
                         (Toml.table probCodec "probability")
        .=  _configProbability
        <*> defaultValue (defaultConfig ^. configProperty)
                         (Toml.table propCodec "property")
        .=  _configProperty

parseConfigFile :: FilePath -> IO Config
parseConfigFile = Toml.decodeFile configCodec

parseConfig :: Text -> Config
parseConfig t = case Toml.decode configCodec t of
    Right c                      -> c
    Left Toml.TrivialError -> error "Trivial error while parsing Toml config"
    Left  (Toml.KeyNotFound   k) -> error $ "Key " ++ show k ++ " not found"
    Left  (Toml.TableNotFound k) -> error $ "Table " ++ show k ++ " not found"
    Left (Toml.TypeMismatch k _ _) ->
        error $ "Type mismatch with key " ++ show k
    Left (Toml.ParseError _) -> error "Config file parse error"
