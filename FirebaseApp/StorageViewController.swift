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
        //        uploadFile()
        //        getImage()
        getDownloadURL()
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
    
    fileprivate func getImage() {
        let downloadRef = Storage.storage().reference(withPath: "memes/680737FC-D2B3-4DBE-B93F-44AA30E13A4F.jpg")
        let taskReferance = downloadRef.getData(maxSize: 4*1024*1024) { [weak self] data, error in
            guard let self = self else {return}
            if let error = error {
                print(#function, error)
            }
            if let data = data {
                self.imageView.image = UIImage(data: data)
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
    
    fileprivate func getDownloadURL() {
        
        let ref = Storage.storage().reference()
        
        let storageReference = ref.child("/memes")
        storageReference.listAll { (result, error) in
            if let error = error {
                print(error)
            }
            guard let items = result?.items else {return}
            for item in items {
                //List storage reference
                let storageLocation = String(describing: item)
                let gsReference = Storage.storage().reference(forURL: storageLocation)
                
                // Fetch the download URL
                gsReference.downloadURL { url, error in
                    if let error = error {
                        // Handle any errors
                        print(error)
                    } else if let url = url {
                        // Get the download URL for each item storage location
                        print(url)
                    }
                }
            }
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
