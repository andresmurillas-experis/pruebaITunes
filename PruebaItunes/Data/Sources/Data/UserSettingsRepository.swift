//
//  File.swift
//  
//
//  Created by Andrés Murillas on 19/7/23.
//

import Foundation
import Combine

public class UserSettingsRepository {
    public static func getUserName(for userId: Int) -> AnyPublisher<UserSettingsDTO, Never> {
        UserSettingsdataSource.readUserSetting(.name, for: userId)
    }
    public static func getUserProfilePicture(for userId: Int) -> AnyPublisher<UserSettingsDTO, Never> {
        UserSettingsdataSource.readUserSetting(.profilePicture, for: userId)
    }
    public static func setUserName(_ name: UserSettingsDTO, for userId: Int) {
        UserSettingsdataSource.setUserSetting(.name, with: name, for: userId)
    }
}
