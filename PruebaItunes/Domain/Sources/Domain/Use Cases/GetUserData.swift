//
//  File.swift
//  
//
//  Created by Andrés Murillas on 19/7/23.
//

import Foundation
import Combine
import Data

public final class GetUserData {
    public static func execute(userId: Int) -> AnyPublisher<UserDataEntity, Never> {
        UserSettingsRepository.getUserSettings(for: userId).map { user in
            UserDataEntity(id: user.id, name: user.name, photo: user.photo)
        }.eraseToAnyPublisher()
    }
}
