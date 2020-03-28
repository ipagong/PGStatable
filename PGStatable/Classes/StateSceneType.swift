//
//  StateControllerType.swift
//  KakaoMobility
//
//  Created suwan.park on 09/07/2019.
//  Copyright © 2019 Mobility-iOS. All rights reserved.
//

import UIKit

/// 기본 StateScene 컨트롤러 인터페이스
public protocol StateSceneType: class {
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
    
    func bindState(_: StateSceneFactory) {  }
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

/// 스토리 보드 베이스의 StateScene 컨트롤러 인터페이스
public protocol StoryboardStateSceneType: StateSceneType {
    /// 스토리보드 파일명.
    static var storyboardIdentifier: String { get }
    
    /// 생성시 베이스가 될 주입할 Bundle.
    static var bundle: Bundle? { get }
}

extension StoryboardStateSceneType {
    static var bundle: Bundle? { return nil }
    
    func bindState(_: StateSceneFactory) {  }
    
    static func createIntance<State: StateSceneFactory>(_ state: State) -> StateSceneType? {
        guard let vc = UIStoryboard(name: Self.storyboardIdentifier, bundle: self.bundle).instantiateViewController(withIdentifier: Self.identifier) as? StateSceneType else { return nil }
        vc.bindState(state)
        return vc
    }
}

/// '스토리 보드 베이스 + 데이타 바인딩' 을 위한 StateScene 컨트롤러 인터페이스
public protocol BindableStoryboardStateSceneType: StoryboardStateSceneType {
    associatedtype SceneValue
    
    /// State 값을 Scene을 위한 데이타로 변경하기 위한 메소드
    /// - Parameter value: ViewController에서 사용하고자 하는 데이타형(associatedtype)으로 변환(옵셔널 캐스팅)하여 주입받는 메소드.
    func bindData(_ value: SceneValue)
}

extension BindableStoryboardStateSceneType where Self : UIViewController {
    func bindState(_ state: StateSceneFactory) {
        guard let value = state.sceneValue as? SceneValue else { return }
        self.bindData(value)
    }
}
