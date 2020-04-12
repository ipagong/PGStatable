//
//  StateType.swift
//  KakaoMobility
//
//  Created suwan.park on 09/07/2019.
//  Copyright © 2019 Mobility-iOS. All rights reserved.
//

import UIKit

/// StateType의 abstract 인터페이스
public protocol AnyStateType {
    /// Scene에서 주입 받을 데이타.
    var sceneData: Any? { get }
}

/// 실제 서비스에서 구현해아할 State(상태) 인터페이스
public protocol StateType: AnyStateType, Equatable {
    /// StateSceneType을 구현한 구현체의 타입을 반환하는 프로퍼티.
    var sceneType: StateSceneType.Type { get }
}

extension StateType {
    /// scene의 팩토리 메소드. 구현체의 타입을 실제화 하여 인터페이스로 반환하는 컴퓨티드 프로퍼티.
    public var scene: StateSceneType? {
        return self.sceneType.createIntance(self)
    }
}
