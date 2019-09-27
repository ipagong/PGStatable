//
//  StateControllerType.swift
//
//  Created by ipagong on 09/07/2019.
//  Copyright © 2019 suwan.park All rights reserved.
//

import UIKit

public protocol StateSceneType : class {
    var stateIdentifier:String? { get set }
    var container:AnyStateContainer? { get set }
}

extension StateSceneType {
    var controller:UIViewController? {
        return self as? UIViewController
    }
}

extension StateSceneType where Self: UIViewController {    
    static func asSelf(_ vc:StateSceneType?) -> Self? {
        return (vc as? Self)
    }
}
