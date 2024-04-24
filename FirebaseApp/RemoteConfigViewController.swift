//
//  ViewController.swift
//  FirebaseApp
//
//  Created by Feqan Aslanli on 21.04.24.
//

import UIKit

class RemoteConfigViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRemoteConfig()
    }
    // MARK: RemoteConfig
    fileprivate func setupRemoteConfig() {
//        FirebaseRemoteConfig.instance.fetchBoolValue(key: "showLabel") { [weak self] value in
//            guard let self = self else {return}
//            if let showLabel = value as? Bool {
//                DispatchQueue.main.async {
//                    self.titleLabel.isHidden = !showLabel
//                }
//            }
//        }
        
        FirebaseRemoteConfig.instance.fetchValues(
            key: "student_model") { [weak self] value in
                guard let self = self else {return}
                if let studentModel = value as? [String: Any],
                   let name = studentModel["name"] as? String {
                        DispatchQueue.main.async {
                            self.titleLabel.text = name
                        }
                    }
            }
    }
}
