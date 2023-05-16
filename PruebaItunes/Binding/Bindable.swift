//
//  Bindable.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 11/5/23.
//

import Foundation

final class Bindable<T> {
    var value: T {
        didSet {
            observer?(value)
        }
    }
    var observer: ((T) -> Void)?
    init(_ value: T) {
        self.value = value
    }
    func bind(_ observer : @escaping (T) -> Void) {
        self.observer = observer
    }
}
