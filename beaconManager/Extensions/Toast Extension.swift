//
//  Toast Extension.swift
//  beaconManager
//
//  Created by Tan Chung Shzen on 27.10.17.
//  Copyright © 2017 HDMI. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(message : String, backgroundColor: UIColor, textColor: UIColor) {

        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let label = UILabel(frame: CGRect.zero)
        label.textAlignment = NSTextAlignment.center
        label.text = message
        label.font = UIFont(name: "Helvetica-Bold", size: 18)
        label.adjustsFontSizeToFitWidth = true
        
        label.backgroundColor =  backgroundColor //UIColor.whiteColor()
        label.textColor = textColor //TEXT COLOR
        
        label.sizeToFit()
        label.numberOfLines = 4
        label.layer.shadowColor = UIColor.gray.cgColor
        label.layer.shadowOffset = CGSize(width: 4, height: 3)
        label.layer.shadowOpacity = 0.3
        label.frame = CGRect(x: appDelegate.window!.frame.size.width, y: 64, width: appDelegate.window!.frame.size.width, height: 44)
        
        label.alpha = 1
        
        appDelegate.window!.addSubview(label)
        
        var basketTopFrame: CGRect = label.frame;
        basketTopFrame.origin.x = 0;
        
        UIView.animate(withDuration
            :2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                label.frame = basketTopFrame
        },  completion: {
            (value: Bool) in
            UIView.animate(withDuration:2.0, delay: 2.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                label.alpha = 0
            },  completion: {
                (value: Bool) in
                label.removeFromSuperview()
            })
        })
    }
    
func showPositiveMessage(message:String)
{
    showAlert(message: message, backgroundColor: UIColor.blue, textColor: UIColor.white)
}
func showNegativeMessage(message:String)
{
    showAlert(message: message, backgroundColor: UIColor.red, textColor: UIColor.white)
}
    
}
