//
//  SettingsViewController.swift
//  Typesetter-text
//
//  Created by Karen Khachatryan on 20.09.24.
//

import UIKit
import PhotosUI

class SettingsViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var menubutton: UIButton!
    private let titlelabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupUI() {
        titlelabel.font = .semibold(size: 24)
        titlelabel.textColor = .white
        setNavigationBar(leftTitle: titlelabel)
        userNameLabel.font = .semibold(size: 24)
        menubutton.titleLabel?.font = .medium(size: 24)
    }

    @IBAction func choosePhoto(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Select Image", message: "Choose a source", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.requestCameraAccess()
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.requestPhotoLibraryAccess()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func clickedMenu(_ sender: UIButton) {
        if let menuVC = self.navigationController?.viewControllers.first(where: { $0 is MenuViewController }) {
            self.navigationController?.popToViewController(menuVC, animated: true)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func clickedContactUs(_ sender: UIButton) {
    }
    @IBAction func clickedPrivacyPolicy(_ sender: UIButton) {
    }
    @IBAction func clickedRateUs(_ sender: UIButton) {
    }
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func requestCameraAccess() {
            let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
            switch cameraStatus {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.openCamera()
                    }
                }
            case .authorized:
                openCamera()
            case .denied, .restricted:
                showSettingsAlert()
            @unknown default:
                break
            }
        }
        
        private func requestPhotoLibraryAccess() {
            let photoStatus = PHPhotoLibrary.authorizationStatus()
            switch photoStatus {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        self.openPhotoLibrary()
                    }
                }
            case .authorized:
                openPhotoLibrary()
            case .denied, .restricted:
                showSettingsAlert()
            case .limited:
                break
            @unknown default:
                break
            }
        }
        
        private func openCamera() {
            DispatchQueue.main.async {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera
                    imagePicker.allowsEditing = true
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
        }
        
        private func openPhotoLibrary() {
            DispatchQueue.main.async {
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.allowsEditing = true
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
        }
        
        private func showSettingsAlert() {
            let alert = UIAlertController(title: "Access Needed", message: "Please allow access in Settings", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            }))
            present(alert, animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                photoImageView.image = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                photoImageView.image = originalImage
            }
            if let imageData = photoImageView.image?.jpegData(compressionQuality: 1.0) {
                let nsData = imageData as NSData
                viewModel.setPhoto(data: nsData)
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}
