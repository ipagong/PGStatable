//
//  StateAnimationType.swift
//  KakaoMobility
//
//  Created suwan.park on 09/07/2019.
//  Copyright © 2019 Mobility-iOS. All rights reserved.
//

import UIKit

public struct StateScene {
    public typealias Completion = () -> ()
    public typealias CustomTransition = (StateSceneType, StateSceneType, StateScene.Completion) -> ()
}

public protocol StateSceneTransitioning : class {
    func transition(from: StateSceneType) -> StateScene.Transition
}

public protocol StateScneneTransitioingDelegate {
    func execute(from: StateSceneType, to: StateSceneType, completion: @escaping StateScene.Completion)
}

extension StateScene {
    public enum Transition {
        case push(duration: TimeInterval = 0.3)
        case pop(duration: TimeInterval = 0.3)
        case present(duration: TimeInterval = 0.3)
        case dismiss(duration: TimeInterval = 0.3)
        case paste
        case fade(scale: CGFloat = 1.0, duration: TimeInterval = 0.3)
        case delegate(transition: StateScneneTransitioingDelegate)
        case functional(transition: StateScene.CustomTransition)
        
        public func execute(from: StateSceneType, to: StateSceneType, completion: @escaping StateScene.Completion) {
            guard let toVc   = to.asController   else { return }
            guard let fromVc = from.asController else { return }
            
            switch self {
            case .push(let duration):
                StateScene.push(from: fromVc, to: toVc, duration: duration, completion: completion)
            case .pop(let duration):
                StateScene.pop(from: fromVc, to: toVc, duration: duration, completion: completion)
            case .present(let duration):
                StateScene.present(from: fromVc, to: toVc, duration: duration, completion: completion)
            case .dismiss(let duration):
                StateScene.dismiss(from: fromVc, to: toVc, duration: duration, completion: completion)
            case .paste:
                StateScene.paste(from: fromVc, to: toVc, completion: completion)
            case .fade(let scale, let duration):
                StateScene.fade(from: fromVc, to: toVc, scale: scale, duration: duration, completion: completion)
            case .delegate(let transition):
                transition.execute(from: from, to: to, completion: completion)
            case .functional(let transition):
                transition(from, to, completion)
            }
        }
    }
}

extension StateScene {
    
    static func push(from: UIViewController, to: UIViewController, duration:TimeInterval = 0.3, completion: @escaping StateScene.Completion) {
        let bounds = from.view.bounds
        
        to.view.layer.shadowColor = UIColor(hexStr: "#000000", alpha: 0.8).cgColor
        to.view.layer.shadowOpacity = 0.1
        to.view.layer.shadowOffset = CGSize(width: -5, height: 0)
        
        to.view.frame = CGRect(x: bounds.width,
                               y: 0,
                               width: bounds.width,
                               height: bounds.height)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [], animations: {
            
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
    
    static func pop(from: UIViewController, to: UIViewController, duration:TimeInterval = 0.3, completion: @escaping StateScene.Completion) {
        let bounds = from.view.bounds
        
        to.view.bringSubviewToFront(from.view)
        
        to.view.layer.shadowColor = UIColor(hexStr: "#000000", alpha: 0.8).cgColor
        to.view.layer.shadowOpacity = 0.1
        to.view.layer.shadowOffset = CGSize(width: -5, height: 0)
        
        to.view.frame = CGRect(x: -bounds.width,
                               y: 0,
                               width: bounds.width,
                               height: bounds.height)
        
        from.view.frame = CGRect(x: 0,
                                 y: 0,
                                 width: bounds.width,
                                 height: bounds.height)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                to.view.frame = CGRect(x: 0,
                                       y: 0,
                                       width: bounds.width,
                                       height: bounds.height)
                
                from.view.frame = CGRect(x: bounds.width * 0.4,
                                         y: 0,
                                         width: bounds.width,
                                         height: bounds.height)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.9, animations: {
            })
            
        }, completion: { _ in
            to.view.layer.shadowColor = UIColor.clear.cgColor
            to.view.layer.shadowOpacity = 0.0
            to.view.layer.shadowOffset = CGSize(width: 0, height: 0)
            
            completion()
        })
    }
    
    static func present(from: UIViewController, to: UIViewController, duration:TimeInterval = 0.3, completion: @escaping StateScene.Completion) {
        
        let bounds = from.view.bounds
        
        to.view.frame = CGRect(x: 0,
                               y: bounds.height,
                               width: bounds.width,
                               height: bounds.height)
        
        UIView.animate(withDuration: duration, animations: {
            to.view.frame = CGRect(x: 0,
                                     y: 0,
                                     width: bounds.width,
                                     height: bounds.height)
            
        }, completion: { _ in
            completion()
        })
    }
    
    static func dismiss(from: UIViewController, to: UIViewController, duration:TimeInterval = 0.3, completion: @escaping StateScene.Completion) {
        from.view.superview?.bringSubviewToFront(from.view)
        
        let bounds = from.view.bounds
        
        from.view.frame = CGRect(x: 0,
                                 y: 0,
                                 width: bounds.width,
                                 height: bounds.height)
        
        UIView.animate(withDuration: duration, animations: {
            from.view.frame = CGRect(x: 0,
                                     y: bounds.height,
                                     width: bounds.width,
                                     height: bounds.height)
        }, completion: { _ in
            completion()
        })
    }
    
    static func paste(from: UIViewController, to: UIViewController, completion: @escaping StateScene.Completion) {
        completion()
    }
    
    static func fade(from: UIViewController, to: UIViewController, scale:CGFloat = 1.0, duration:TimeInterval = 0.3, completion: @escaping StateScene.Completion) {
        to.view.alpha = 0.0
        to.view.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        UIView.animate(withDuration: duration, animations: {
            to.view.alpha = 1.0
            to.view.transform = CGAffineTransform.identity
        }, completion: { _ in
            completion()
        })
    }

}

extension UIColor {
    fileprivate convenience init(hexStr:String, alpha:CGFloat = 1.0){
        var rgbValue:UInt64 = 0
        let trimedHexStr = hexStr.trimmingCharacters(in: CharacterSet.whitespaces)
        let scanner:Scanner = Scanner(string:trimedHexStr)
        
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt64(&rgbValue)
        
        let red   : CGFloat = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green : CGFloat = CGFloat((rgbValue & 0x00FF00) >> 8 ) / 255.0
        let blue  : CGFloat = CGFloat( rgbValue & 0x0000FF)        / 255.0
        
        self.init(red:   red,
                  green: green,
                  blue:  blue,
                  alpha: alpha)
    }
}
