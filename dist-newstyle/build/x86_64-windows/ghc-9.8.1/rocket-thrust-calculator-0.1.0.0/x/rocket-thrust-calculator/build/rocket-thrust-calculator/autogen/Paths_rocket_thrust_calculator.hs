{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
#if __GLASGOW_HASKELL__ >= 810
{-# OPTIONS_GHC -Wno-prepositive-qualified-module #-}
#endif
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_rocket_thrust_calculator (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath




bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "C:\\cabal\\bin"
libdir     = "C:\\cabal\\x86_64-windows-ghc-9.8.1\\rocket-thrust-calculator-0.1.0.0-inplace-rocket-thrust-calculator"
dynlibdir  = "C:\\cabal\\x86_64-windows-ghc-9.8.1"
datadir    = "C:\\cabal\\x86_64-windows-ghc-9.8.1\\rocket-thrust-calculator-0.1.0.0"
libexecdir = "C:\\cabal\\rocket-thrust-calculator-0.1.0.0-inplace-rocket-thrust-calculator\\x86_64-windows-ghc-9.8.1\\rocket-thrust-calculator-0.1.0.0"
sysconfdir = "C:\\cabal\\etc"

getBinDir     = catchIO (getEnv "rocket_thrust_calculator_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "rocket_thrust_calculator_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "rocket_thrust_calculator_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "rocket_thrust_calculator_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "rocket_thrust_calculator_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "rocket_thrust_calculator_sysconfdir") (\_ -> return sysconfdir)



joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '\\'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/' || c == '\\'
