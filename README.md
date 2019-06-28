# Linear Types GHC in Docker

## How to use

1. Place ``Main.hs`` .
2. Run ``docker-compose up -d``
3. Run ``docker-compose exec playground cabal new-repl``

## Sample

```haskell
{-# LANGUAGE BlockArguments    #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RebindableSyntax  #-}
{-# LANGUAGE RecordWildCards   #-}

module Main where

import           Prelude                      hiding (Monad(..), MonadFail(..))
import           Prelude.Linear               (Unrestricted(..))
import qualified Control.Monad.Linear.Builder as Linear
import qualified System.IO                    as System
import qualified System.IO.Resource           as RIO
import           Data.String                  (fromString)

main :: IO ()
main = RIO.run $ writeSomething "something.txt"

writeSomething :: FilePath -> RIO.RIO (Unrestricted ())
writeSomething path = do
    h0 <- RIO.openFile path System.WriteMode
    h1 <- RIO.hPutStr h0 "some"
    h2 <- RIO.hPutStr h1 "thing"
    RIO.hClose h2
    return (Unrestricted ())
  where
    Linear.Builder{..} = Linear.monadBuilder
```
