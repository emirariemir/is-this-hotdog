//
//  ViewController.swift
//  IsThisHotdog
//
//  Created by Emir on 23.07.2023.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userTookedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userTookedImage
        }
    }

    @IBAction func takePhotoPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true)
    }
    
}

