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
            guard let ciImage = CIImage(image: userTookedImage) else {
                fatalError("Could not convert it into a CIImage!")
            }
            determine(processThis: ciImage)
        }
        imagePicker.dismiss(animated: true)
    }
    
    func determine (processThis image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3(configuration: MLModelConfiguration()).model) else {
            fatalError("Failed to create a CoreML model")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Failed to load the results")
            }
            if let firstGuess = results.first {
                if firstGuess.identifier.contains("hotdog") {
                    self.navigationItem.title = "It's a Hotdog!"
                } else {
                    self.navigationItem.title = "Not a Hotdog."
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }

    @IBAction func takePhotoPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true)
    }
    
}

