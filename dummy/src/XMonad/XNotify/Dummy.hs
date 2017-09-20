{-# LANGUAGE MultiParamTypeClasses #-}
module XMonad.XNotify.Dummy where

import XMonad
import XMonad.XNotify.Class

instance IsNotification () where
  summary = const ()
  body = const ()
  icon = const ()

instance HasNotifications () X where
  notify = const $ const $ pure ()
  freshNotify = const $ pure ()

instance HasNotifications () IO where
  notify = const $ const $ pure ()
  freshNotify = const $ pure ()

