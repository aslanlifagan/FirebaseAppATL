//
//  FirebaseConfiguration.swift
//  FirebaseApp
//
//  Created by Feqan Aslanli on 21.04.24.
//

import FirebaseCore
class FirebaseConfiguration {
    static let shared = FirebaseConfiguration()
       private init() {}
       
       func start() {
           FirebaseApp.configure()
       }
}
