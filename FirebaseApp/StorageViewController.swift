//
//  StorageViewController.swift
//  FirebaseApp
//
//  Created by Feqan Aslanli on 22.04.24.
//

import UIKit
import FirebaseStorage
class StorageViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var uploadButton: UIButton!
    @IBOutlet private weak var addButton: UIButton!
    
    private lazy var imagePicker: ImagePicker = {
        let imagePicker = ImagePicker()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    @IBAction func uploadAction(_ sender: UIButton) {
        uploadFile()
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        imagePicker.photoGalleryAccessRequest()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    fileprivate func setupView() {
    }
    
    fileprivate func uploadFile() {
        let randomID = UUID().uuidString
        let uploadRef = Storage.storage().reference(withPath: "memes/\(randomID).jpg")
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.75) else {return}
        
        let updateMetadata = StorageMetadata.init()
        updateMetadata.contentType = "image/jpeg"
        let taskReferance = uploadRef.putData(
            imageData, metadata: updateMetadata) {
                downloadMetadata, error in
                if let error = error {
                    print(#function, error)
                }
                if let data = downloadMetadata {
                    print("data", data)
                }
            }
        taskReferance.observe(.progress) { [weak self] picture in
            guard let self = self else {return}
            guard let pictureState = picture.progress?.fractionCompleted else {return}
            print("pictureState",pictureState)
            self.progressView.progress = Float(pictureState)
        }
    }
}

// MARK: ImagePickerDelegate

extension StorageViewController: ImagePickerDelegate {
    
    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage) {
        imageView.image = image
        imagePicker.dismiss()
    }
    
    func cancelButtonDidClick(on imageView: ImagePicker) { imagePicker.dismiss() }
    func imagePicker(
        _ imagePicker: ImagePicker, grantedAccess: Bool,
        to sourceType: UIImagePickerController.SourceType) {
            guard grantedAccess else { return }
            imagePicker.present(parent: self, sourceType: sourceType)
        }
}
