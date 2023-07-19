//
//  File.swift
//  
//
//  Created by Andrés Murillas on 19/7/23.
//

import Foundation

public struct UserDataDTO: Decodable {
    public var id: Int
    public var name: String
    public var photo: Data
    init(id: Int, name: String, photo: Data) {
        self.id = id
        self.name = name
        self.photo = photo
    }
}
