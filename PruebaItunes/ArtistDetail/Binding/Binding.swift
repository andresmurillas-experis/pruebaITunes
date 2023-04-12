//
//  Binding.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 12/4/23.
//

import Foundation

final class Bindable <T> {
    var value: T {
        didSet {
            observer(value)
        }
    }
    var observer: ((T) -> Void)
    init(_ value: T, _ observer: @escaping ((T) -> Void)) {
        self.observer = observer
        self.value = value
    }
}
