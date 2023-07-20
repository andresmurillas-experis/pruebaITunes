//
//  File.swift
//  
//
//  Created by Andrés Murillas on 20/7/23.
//

import Foundation
import Combine
import Data

public final class GetUserName {
    public static func execute(userId: Int) -> AnyPublisher<UserSettingsEntity, Never> {
        UserSettingsRepository.getUserName(for: userId).map { user in
             UserSettingsEntity(id: user.id, name: user.name, photo: user.photo)
        }.eraseToAnyPublisher()
    }
}
