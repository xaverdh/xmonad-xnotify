{-# LANGUAGE MultiParamTypeClasses #-}
module XMonad.XNotify.NotifySend where

import XMonad

import XMonad.XNotify.Class
import XMonad.XNotify.NotifySend.Impl


instance HasNotifications Notification X where
  notify = const notifySend

instance HasNotifications Notification IO where
  notify = const notifySend


