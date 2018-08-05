module XMonad.XNotify.NotifySend.Impl where

import Data.Monoid
import Data.Maybe
import Control.Monad.IO.Class

import XMonad.Util.Run (safeSpawn)
import XMonad.XNotify.Class



data Notification = Notification
  { notSummary :: Maybe String
  , notBody :: Maybe String
  , notIcon :: Maybe String }

instance Semigroup Notification where
  n1 <> n2 = Notification
    { notSummary = maybe (notSummary n2) Just (notSummary n1)
    , notBody = maybe (notBody n2) Just (notBody n1)
    , notIcon = maybe (notIcon n2) Just (notIcon n1) }
 
instance Monoid Notification where
  mempty = Notification Nothing Nothing Nothing

fromSummary :: String -> Notification
fromSummary s = mempty { notSummary = Just s }

fromBody :: String -> Notification
fromBody b = mempty { notBody = Just b }

fromIcon :: Icon -> Notification
fromIcon i = mempty { notIcon = Just (iconPath i) }

notifySend :: MonadIO io => Notification -> io ()
notifySend n = safeSpawn "notify-send" args
  where
    args = useIcon (notIcon n)
      <> useSummary (notSummary n)
      <> useBody (notBody n)
    useIcon = maybe [] $ \i -> ["-i",i]
    useSummary = pure . fromMaybe " "
    useBody = pure . fromMaybe " "

instance IsNotification Notification where
  summary = fromSummary
  body = fromBody
  icon = fromIcon


