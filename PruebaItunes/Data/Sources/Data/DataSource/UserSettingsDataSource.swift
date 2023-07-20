//
//  File.swift
//  
//
//  Created by Andrés Murillas on 19/7/23.
//

import Foundation
import Combine

public final class UserSettingsdataSource {
    public enum UserSettingEntry: String {
        case name = "name", profilePicture = "picture"
    }
    public static func readUserSetting(_ settingEntry: UserSettingEntry,for userId: Int) -> AnyPublisher<UserSettingsDTO, Never> {
        let userDefaults = UserDefaults(suiteName: "group.com.PruebaItunes")
        let userData: UserSettingsDTO = userDefaults?.object(forKey: ("\(userId)-\(settingEntry)")) as! UserSettingsDTO
        let subject = PassthroughSubject<UserSettingsDTO, Never>()
        subject.send(userData)
        return subject.eraseToAnyPublisher()
    }
    public static func setUserSetting(_ settingEntry: UserSettingEntry, with userSettings: UserSettingsDTO, for userId: Int) {
        let userDefaults = UserDefaults(suiteName: "group.com.PruebaItunes")
        userDefaults?.set(userSettings, forKey: "\(userId)-\(settingEntry)")
    }
}
