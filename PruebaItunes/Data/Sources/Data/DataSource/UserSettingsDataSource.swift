//
//  File.swift
//  
//
//  Created by Andrés Murillas on 19/7/23.
//

import Foundation
import Combine

public final class UserSettingsdataSource {
    public static func readUserSettings(for userId: Int) -> AnyPublisher<UserDataDTO, Never> {
        let userDefaults = UserDefaults(suiteName: "group.com.PruebaItunes")
        let userData: UserDataDTO = userDefaults?.object(forKey: ("\(userId)")) as! UserDataDTO
        let subject = PassthroughSubject<UserDataDTO, Never>()
        subject.send(userData)
        return subject.eraseToAnyPublisher()
    }
}
