//
//  StateContainer.swift
//  KakaoMobility
//
//  Created suwan.park on 09/07/2019.
//  Copyright © 2019 Mobility-iOS. All rights reserved.
//

import UIKit

public protocol AnyStateContainerType: class {
    func invoke(any state: AnyStateType)
    func undo()
}

public protocol StateContainerType: AnyStateContainerType {
    associatedtype State: StateType
    
    func invoke(state: State)
}

extension StateContainerType {
    public func invoke(any state: AnyStateType) {
        guard let state = state as? State else { return }
        self.invoke(state: state)
    }
}

open class StateContainer<State>: UIViewController, StateContainerType where State: StateType {
    typealias Completion = (Bool) -> ()
    
    fileprivate let store = StateStore<State>()
    
    var didUpdated: StateContainer.Completion?
    
    open func invoke(state: State) {
        guard self.shouldChange(state: state) == true else {return }
        
        self.push(state: state)
        
        self.didChange(state: state)
    }
    
    open func undo() { self.pop() }
    open func shouldChange(state: State) -> Bool { true }
    open func didChange(state: State) { }
    
    public func current() -> State? { self.store.current() }
}

extension StateContainer {
    final public func push(state: State)  {
        self.update(state: state)
        self.store.invoke(state: state)
    }
    
    final private func pop() {
        let prev = self.store.undo()
        self.update(state: prev)
    }
    
    final private func update(state: State?) {
        self.should(state: state, didUpdated: self.didUpdated)
    }
    
    func should(state: State?, didUpdated: StateContainer.Completion?) {
        guard let state = state else {
            didUpdated?(false)
            return
        }
        
        if state == self.store.current() {
            self.prevScene?.bindState(state)
            didUpdated?(true)
            return
        }
        
        _dismissAllPresentedControllers { [weak self] in
            self?.performScene(with: state)
            didUpdated?(true)
        }
    }
}

extension StateContainer {
    func performScene(with state: State?) {
        guard let to   = state?.scene else { return }
        guard let toVc = to.asController else { return }
        
        let fromScene = self.prevScene
        
        self.paste(toVc)
        
        guard let from   = fromScene else { return }
        guard let fromVc = from.asController else { return }
        
        self.transition(from: from, to: to) { [weak self] in self?.remove(from: fromVc) }
    }
}

extension StateContainer {
    private func paste(_ to: UIViewController) {
        self.addChild(to)
        self.view.addSubview(to.view)

        to.view.frame = view.bounds
        to.didMove(toParent: self)
        
        to.view.setNeedsLayout()
        to.view.layoutIfNeeded()
    }
    
    private func transition(from: StateSceneType, to: StateSceneType, completion: @escaping StateScene.Completion) {
        guard let target = to as? StateSceneTransitioning else {
            completion()
            return
        }
        
        target.transition(from: from).execute(from: from, to: to) { completion() }
    }
    
    private func remove(from: UIViewController) {
        from.willMove(toParent: nil)
        from.view.removeFromSuperview()
        from.removeFromParent()
    }
}

extension StateContainer {
    var prevScene:StateSceneType? { return self.children.first as? StateSceneType }
}

extension UIViewController {
    fileprivate func _dismissAllPresentedControllers(_ completion: (() -> (Void))? = nil) {
        guard let present = self.presentedViewController else {
            completion?()
            return
        }
        
        present._dismissAllPresentedControllers { [weak present] in
            present?.dismiss(animated: true, completion: completion)
        }
    }
}
