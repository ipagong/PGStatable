//
//  StateStoreType.swift
//  KakaoMobility
//
//  Created suwan.park on 09/07/2019.
//  Copyright © 2019 Mobility-iOS. All rights reserved.
//

import UIKit

/// StateContainer 내부의 State를 관리하는 저장체 /n
/// 내부는 평범한 스택으로 구현되어있음.
class StateStore<State: StateType> {
    /// Generic 스택.
    private var stack: StoreStack<State> = StoreStack<State>()
}

extension StateStore {
    /// push의 메소드래퍼
    /// - Parameter state: 상태값.
    func invoke(state: State) {
        guard self.current() != state else { return }
        
        self.stack.push(element: state)
    }
    
    /// pop의 메소드래퍼
    func undo() -> State? {
        guard let poped = self.stack.pop() else { return nil }
        let state = self.stack.peek() ?? poped

        return state
    }
    
    /// peek의 메소드래퍼
    func current() -> State? {
        return self.stack.peek()
    }
}

fileprivate struct StoreStack<T: StateType> {
    private var elements = [T]()
    public init() {}
    
    fileprivate mutating func push(element: T)   { self.elements.append(element)     }
    fileprivate mutating func pop() -> T?        { return self.elements.popLast()    }
    fileprivate func peek() -> T?                { return self.elements.last         }
    fileprivate var isEmpty: Bool                { return self.elements.isEmpty      }
    fileprivate var count: Int                   { return self.elements.count        }
}

extension StoreStack: CustomStringConvertible {
    public var description: String { return self.elements.description }
}

extension StoreStack: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: T...) {
        self.init()
        self.elements.append(contentsOf: elements)
    }
}

struct ArrayIterator<T>: IteratorProtocol {
    var currentElement: [T]
    
    init(elements: [T]) {
        self.currentElement = elements
    }
    
    public mutating func next() -> T? {
        return self.currentElement.popLast()
    }
}

extension StoreStack: Sequence {
    public func makeIterator() -> ArrayIterator<T> {
        return ArrayIterator<T>(elements: self.elements)
    }
}
