//
//  Binding.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 12/4/23.
//

import Foundation

final class Bindable <T> {
    var observer: ((T) -> Void)?
    init(_ observer: @escaping ((T) -> Void)) {
        self.observer = observer
    }
    func bind(_ value: T) {
        observer?(value)
    }
}
