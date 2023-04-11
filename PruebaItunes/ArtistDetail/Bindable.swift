//
//  File.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 10/4/23.
//
//
import Foundation

class Bindable <T> {
    var albumList: T {
        didSet {
            bind()
        }
    }
    typealias onChange = (T) -> Void

    var changeList: onChange = { _ in
        return
    }

    init(_ albumList: T) {
        self.albumList = albumList

    }

    func bind() {
        changeList(albumList)
    }
}
