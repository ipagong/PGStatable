//
//  StateType.swift
//  KakaoMobility
//
//  Created suwan.park on 09/07/2019.
//  Copyright © 2019 Mobility-iOS. All rights reserved.
//

import UIKit

/// StateType의 abstract 인터페이스
public protocol AnyStateType { }

/// 실제 서비스에서 구현해아할 State(상태) 인터페이스
public protocol StateType : AnyStateType {
    associatedtype Data : Equatable
    
    /// 상태별 Equtable을 데이타 비교를 위한 프로퍼티.
    var dataKey:Data?     { get }
    
    /// 해당 상태가 Scene의 존재 여부를 위한 프로퍼티.
    var hasScene:Bool     { get }
}

extension StateType {
    var hasScene:Bool { return true }
}

/// 상태별 Scene을 노출할 베이스갈 ViewController 지정하기 위한 인터페이스.
public protocol StateSceneFactory {
    /// Scene에서 주입 받을 데이타.
    var sceneValue:Any? { get }
    
    /// StateSceneType을 구현한 구현체의 타입을 반환하는 프로퍼티.
    var sceneType:StateSceneType.Type { get }
}

public extension StateSceneFactory where Self : StateType {
    /// scene의 팩토리 메소드. 구현체의 타입을 실제화 하여 인터페이스로 반환하는 컴퓨티드 프로퍼티.
    var scene:StateSceneType? {
        return self.sceneType.createIntance(self)
    }
}
