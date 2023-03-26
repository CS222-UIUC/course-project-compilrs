//
//  DataStructures.swift
//  addez
//
//  Created by Ayush Raman on 3/21/23.
//

import Foundation

struct Stack<T> {
    private var array: [T] = []
    mutating func push(_ element: T) {
        array.append(element)
    }
    @discardableResult mutating func pop() -> T? {
        guard !array.isEmpty else { return .none }
        return array.removeLast()
    }
    func peek() -> T? {
        guard !array.isEmpty else { return .none }
        return array.last
    }
    func empty() -> Bool {
        array.isEmpty
    }
}
