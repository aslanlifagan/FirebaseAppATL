//
//  FirebaseRemoteConfig.swift
//  FirebaseApp
//
//  Created by Feqan Aslanli on 21.04.24.
//

import Foundation
import FirebaseRemoteConfig

class FirebaseRemoteConfig {
    static let instance = FirebaseRemoteConfig()
    private let remoteConfig = RemoteConfig.remoteConfig()
    private init() {}
    
    func fetchValues(defaults: [String: NSObject] = [:],
                     key: String,
                     onComplete: @escaping ((Any) -> Void)) {
        remoteConfig.setDefaults(defaults)
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        self.remoteConfig.fetch(withExpirationDuration: 0) { status, error in
            if status == .success, error == nil {
                self.remoteConfig.activate { _, error  in
                    guard error == nil else {return}
                    let value = self.remoteConfig.configValue(forKey: key).jsonValue
                    onComplete(value ?? [String: Any]())
                }
            }
        }
    }
}
