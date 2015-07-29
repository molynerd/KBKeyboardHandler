//
//  KeyboardHandlerDelegate.swift
//  MyOrders
//
//  Created by Nicholas Molyneux on 7/27/15.
//  Copyright © 2015 Superior Mobile Medics. All rights reserved.
//

import Foundation
import UIKit

protocol KBKeyboardHandlerDelegate {
    /// Resize / reposition your views here. All actions performed here
    /// will appear animated.
    /// delta is the difference between the previous size of the keyboard
    /// and the new one.
    /// For instance when the keyboard is shown,
    /// delta may have width=768, height=264,
    /// when the keyboard is hidden: width=-768, height=-264.
    /// Use keyboard.frame.size to get the real keyboard size.
    func keyboardSizeChanged(delta:CGSize)
}

class KBKeyboardHandler: NSObject {
    var frame:CGRect = CGRectZero
    var delegate:KBKeyboardHandlerDelegate?
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let oldFrame = self.frame;
        self.retrieveFrameFromNotification(notification)
        if oldFrame.size.height != self.frame.size.height {
            let delta = CGSizeMake(self.frame.size.width - oldFrame.size.width, self.frame.size.height - oldFrame.size.height)
            if self.delegate != nil {
                self.notifySizeChanged(delta, notification: notification)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.frame.size.height > 0.0 {
            self.retrieveFrameFromNotification(notification)
            let delta = CGSizeMake(-self.frame.size.width, -self.frame.size.height)
            if self.delegate != nil {
                self.notifySizeChanged(delta, notification: notification)
            }
        }
        self.frame = CGRectZero
    }
    
    func retrieveFrameFromNotification(notification: NSNotification) {
        if let kbRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            self.frame = UIApplication.sharedApplication().keyWindow?.rootViewController?.view.convertRect(kbRect, fromView: nil) ?? CGRectZero
            return
        }
        self.frame = CGRectZero
    }
    
    func notifySizeChanged(delta:CGSize, notification:NSNotification) {
        let info = notification.userInfo

        if let curve = info?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber,
            duration = info?[UIKeyboardAnimationDurationUserInfoKey] as? NSTimeInterval {
                //convert the curve to an option
                let curveOption = UIViewAnimationOptions(rawValue: UInt(curve.unsignedIntValue << 16))
                let animationClosure = { () -> Void in
                    if let d = self.delegate {
                        d.keyboardSizeChanged(delta)
                    }
                }
                
                UIView.animateWithDuration(duration, delay: 0.0, options: curveOption, animations: animationClosure, completion: nil)
        }
    }
}