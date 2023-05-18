//
//  Bindable.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 11/5/23.
//

import Foundation

final class Bindable<T> {
    typealias observerType = ((T?) -> Void)
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    var observer: observerType?
    init(_ value: T?) {
        self.value = value
    }
    func bind(_ observer : @escaping observerType) {
        self.observer = observer
    }
}
