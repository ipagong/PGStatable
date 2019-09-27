//
//  StateAnimationType.swift
//
//  Created by ipagong on 09/07/2019.
//  Copyright © 2019 suwan.park All rights reserved.
//

import UIKit

struct StateScene { typealias Completion = () -> () }

protocol StateSceneTransitioning {
    func transition(from: StateSceneType, to: StateSceneType, completion: @escaping StateScene.Completion)
}

extension StateSceneTransitioning where Self : UIViewController {
    
    func push(from: UIViewController, to: UIViewController, completion: @escaping StateScene.Completion) {
        let bounds = self.view.bounds
        
        to.view.layer.shadowColor = UIColor(hexStr: "#000000", alpha: 0.8).cgColor
        to.view.layer.shadowOpacity = 0.1
        to.view.layer.shadowOffset = CGSize(width: -5, height: 0)
        
        to.view.frame = CGRect(x: bounds.width,
                               y: 0,
                               width: bounds.width,
                               height: bounds.height)
        
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                to.view.frame = CGRect(x: 0,
                                       y: 0,
                                       width: bounds.width,
                                       height: bounds.height)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.9, animations: {
                from.view.frame = CGRect(x: -bounds.width/4,
                                         y: 0,
                                         width: bounds.width,
                                         height: bounds.height)
            })
            
        }, completion: { _ in
            to.view.layer.shadowColor = UIColor.clear.cgColor
            to.view.layer.shadowOpacity = 0.0
            to.view.layer.shadowOffset = CGSize(width: 0, height: 0)
            
            completion()
        })
    }
    
    func pop(from: UIViewController, to: UIViewController, completion: @escaping StateScene.Completion) {
        let bounds = self.view.bounds
        
        self.view.bringSubviewToFront(from.view)
        
        from.view.layer.shadowColor = UIColor(hexStr: "#000000", alpha: 0.8).cgColor
        from.view.layer.shadowOpacity = 0.1
        from.view.layer.shadowOffset = CGSize(width: -5, height: 0)
        
        let x = bounds.width * 0.4
        
        to.view.frame = CGRect(x: -x,
                               y: 0,
                               width: bounds.width,
                               height: bounds.height)
        
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                to.view.frame = CGRect(x: 0,
                                       y: 0,
                                       width: bounds.width,
                                       height: bounds.height)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.9, animations: {
                from.view.frame = CGRect(x: bounds.width,
                                         y: 0,
                                         width: bounds.width,
                                         height: bounds.height)
            })
            
        }, completion: { _ in
            to.view.layer.shadowColor = UIColor.clear.cgColor
            to.view.layer.shadowOpacity = 0.0
            to.view.layer.shadowOffset = CGSize(width: 0, height: 0)
            
            completion()
        })
    }
    
    func modal(from: UIViewController, to: UIViewController, completion: @escaping StateScene.Completion) {
        
        let bounds = self.view.bounds
        
        to.view.frame = CGRect(x: 0,
                               y: bounds.height,
                               width: bounds.width,
                               height: bounds.height)
        
        UIView.animate(withDuration: 0.3, animations: {
            to.view.frame = CGRect(x: 0,
                                     y: 0,
                                     width: bounds.width,
                                     height: bounds.height)
            
        }, completion: { _ in
            completion()
        })
    }
    
    func dismiss(from: UIViewController, to: UIViewController, completion: @escaping StateScene.Completion) {
        self.view.bringSubviewToFront(from.view)
        
        let bounds = self.view.bounds
        
        from.view.frame = CGRect(x: 0,
                                 y: 0,
                                 width: bounds.width,
                                 height: bounds.height)
        
        UIView.animate(withDuration: 0.3, animations: {
            from.view.frame = CGRect(x: 0,
                                     y: bounds.height,
                                     width: bounds.width,
                                     height: bounds.height)
            
        }, completion: { _ in
            completion()
        })
    }
    
    func paste(from: UIViewController, to: UIViewController, completion: @escaping StateScene.Completion) {
        completion()
    }
    
    func fade(from: UIViewController, to: UIViewController, scale:CGFloat = 1.0, completion: @escaping StateScene.Completion) {
        to.view.alpha = 0.0
        to.view.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        UIView.animate(withDuration: 0.3, animations: {
            to.view.alpha = 1.0
            to.view.transform = CGAffineTransform.identity
        }, completion: { _ in
            completion()
        })
    }

}

extension UIColor {
    fileprivate convenience init(hexStr:String, alpha:CGFloat = 1.0){
        var rgbValue:UInt32 = 0
        let trimedHexStr = hexStr.trimmingCharacters(in: CharacterSet.whitespaces)
        let scanner:Scanner = Scanner(string:trimedHexStr)
        scanner.scanLocation = 1    //by pass '#'
        scanner.scanHexInt32(&rgbValue)
        let rgbRed:CGFloat = CGFloat((rgbValue & 0xFF0000)>>16)/255.0
        let rgbGreen:CGFloat = CGFloat((rgbValue & 0x00FF00)>>8)/255.0
        let rgbBlue:CGFloat = CGFloat(rgbValue & 0x0000FF)/255.0
        
        self.init(red: rgbRed, green: rgbGreen, blue: rgbBlue, alpha: alpha)
    }
}
