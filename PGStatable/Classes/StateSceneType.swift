//
//  StateControllerType.swift
//  
//
//  Created by ipagong on 09/07/2019.
//  Copyright © 2019 suwan.park All rights reserved.
//

import UIKit

/// 기본 StateScene 컨트롤러 인터페이스
public protocol StateSceneType : class {
    /// ViewController 식별자. (Xib 로드용)
    static var identifier: String { get }
    
    /// ViewController 팩토리 메소드
    /// - Parameter state: ViewController 내부에서 사용하기 위한 상태값.
    static func createIntance<State: StateSceneFactory>(_ state:State) -> StateSceneType?
    
    /// ViewController가 생성된 후, 데이타 주입하는 메소드.
    /// - Parameter state: ViewController 내부에서 사용하기 위한 상태값.
    func bindState(_ : StateSceneFactory)
}

extension StateSceneType where Self : NSObject {
    static var identifier: String { return String(describing: self) }
    
    func bindState(_ : StateSceneFactory) {  }
}

extension StateSceneType {
    /// ViewController로 변환용.
    var asController:UIViewController? { return self as? UIViewController }
    
    /// StateContainner 프로퍼미 (navigationController 와 유사)
    var stateContainer:AnyStateContainerType? { self.asController?.parent as? AnyStateContainerType }
    
    /// 컨트롤러 내부에서 State 값을 변환하여 화면 전환을 위한 것. (push 와 유사)
    /// - Parameter state:
    func invoke<State:StateType>(state:State) { self.stateContainer?.invoke(state: state) }
    
    /// 컨트롤러 내부에서 이전 State 값으로 변환하며 화면 전환을 위한 것. (pop 과 유사)
    func undo() { self.stateContainer?.undo() }
}
