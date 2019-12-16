//
//  StoryboardStateSceneType.swift
//  PGStatable
//
//  Created by ipagong on 16/12/2019.
//  Copyright © 2019 suwan.park All rights reserved.
//

import Foundation

/// 스토리 보드 베이스의 StateScene 컨트롤러 인터페이스
public protocol StoryboardStateSceneType : StateSceneType {
    /// 스토리보드 파일명.
    static var storyboardIdentifier : String { get }
    
    /// 생성시 베이스가 될 주입할 Bundle.
    static var bundle:Bundle? { get }
}

extension StoryboardStateSceneType {
    static var bundle:Bundle? { return nil }
    
    func bindState(_ : StateSceneFactory) {  }
    
    static func createIntance<State: StateSceneFactory>(_ state:State) -> StateSceneType? {
        guard let vc = UIStoryboard(name: Self.storyboardIdentifier, bundle: self.bundle).instantiateViewController(withIdentifier: Self.identifier) as? StateSceneType else { return nil }
        vc.bindState(state)
        return vc
    }
}

/// '스토리 보드 베이스 + 데이타 바인딩' 을 위한 StateScene 컨트롤러 인터페이스
public protocol BindableStoryboardStateSceneType : StoryboardStateSceneType {
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
