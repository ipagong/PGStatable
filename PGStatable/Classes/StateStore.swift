//
//  StateStoreType.swift
//
//  Created by ipagong on 09/07/2019.
//  Copyright © 2019 suwan.park All rights reserved.
//

import UIKit

class StateStore<State:StateType> {
    private var stack:StoreStack<State> = StoreStack<State>()
}

extension StateStore {
    func invoke(state:State) {
        guard self.current() != state else { return }
        
        self.stack.push(element: state)
    }
    
    func undo() -> State? {
        guard let poped = self.stack.pop() else { return nil }
        let state = self.stack.peek() ?? poped

        return state
    }
    
    func current() -> State? {
        return self.stack.peek()
    }
}

struct StoreStack<T:StateType> {
    private var elements = [T]()
    public init() {}
    
    public mutating func push(element: T)   { self.elements.append(element)     }
    public mutating func pop() -> T?        { return self.elements.popLast()    }
    public func peek() -> T?                { return self.elements.last         }
    public var isEmpty: Bool                { return self.elements.isEmpty      }
    public var count: Int                   { return self.elements.count        }
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
