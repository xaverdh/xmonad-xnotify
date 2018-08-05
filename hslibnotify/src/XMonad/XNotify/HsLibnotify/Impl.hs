{-# LANGUAGE GeneralizedNewtypeDeriving, FlexibleInstances #-}
module XMonad.XNotify.HsLibnotify.Impl where

import XMonad
import qualified XMonad.Util.ExtensibleState as XS
import qualified Libnotify as N
import qualified Data.Map as M
import Data.Monoid
import Control.Monad.Extra

import XMonad.XNotify.Class


type MNotification = N.Mod N.Notification

instance IsNotification MNotification where
  summary = N.summary
  body = N.body
  icon = N.icon . iconPath



newtype Tokens t = Tokens
  { tokenMap :: M.Map t N.Notification }
  deriving (Semigroup,Monoid,Typeable)

instance (Typeable i,Ord i) => ExtensionClass (Tokens i) where
  initialValue = mempty



notifyXRaw :: TokenSelector t
  => Maybe t
  -> ( Maybe N.Notification -> X MNotification )
  -> X ()
notifyXRaw msel f
  | Nothing <- msel = 
    f Nothing >>= void . liftIO . N.display
  | Just sel <- msel = do
    modn <- f =<< XS.gets ( M.lookup sel . tokenMap )
    n' <- liftIO $ N.display modn
    XS.modify $ Tokens . M.insert sel n' . tokenMap

notifyX :: TokenSelector t => t -> MNotification -> X ()
notifyX sel n = notifyXRaw (Just sel) $ \n' ->
  pure $ n <> maybe mempty N.reuse n'

freshNotifyX :: MNotification -> X ()
freshNotifyX n = notifyXRaw
  ( Nothing :: Maybe TkFresh ) $ const (pure n)


notifyIO :: TokenSelector t => t -> MNotification -> IO ()
notifyIO _ = void . N.display


