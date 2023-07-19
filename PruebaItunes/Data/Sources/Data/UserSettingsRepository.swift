//
//  File.swift
//  
//
//  Created by Andrés Murillas on 19/7/23.
//

import Foundation
import Combine

public class UserSettingsRepository {
    public static func getUserSettings(for artistId: Int) -> AnyPublisher<UserDataDTO, Never> {
        UserSettingsdataSource.readUserSettings(for: artistId)
    }
}
