{-# LANGUAGE GeneralizedNewtypeDeriving, MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
module XMonad.XNotify.HsLibnotify where

import XMonad

import XMonad.XNotify.Class
import XMonad.XNotify.HsLibnotify.Impl


instance HasNotifications MNotification X where
  notify = notifyX
  freshNotify = freshNotifyX

instance HasNotifications MNotification IO where
  notify = notifyIO


