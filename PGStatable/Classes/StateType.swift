//
//  StateType.swift
//
//  Created by ipagong on 09/07/2019.
//  Copyright © 2019 suwan.park All rights reserved.
//

import Foundation

public protocol AnyStateType { }

public protocol StateType : AnyStateType, Equatable {
    var dataKey:String?             { get }
    var identifier:String           { get }
    var hasScene:Bool               { get }
}

public protocol StateSceneFactory {
    var storyboardIdentifier : String? { get }
    var vcIdentifier: String? { get }
    
    func bindData(with scene:StateSceneType?)
}

public extension StateSceneFactory where Self : StateType {
    var scene:StateSceneType? {
        guard let storyboard = self.storyboardIdentifier else { return nil }
        guard let identifier = self.vcIdentifier         else { return nil }
        
        guard let vc = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier) as? StateSceneType else { return nil }
        vc.stateIdentifier = self.identifier
        self.bindData(with: vc)
        return vc
    }
}
