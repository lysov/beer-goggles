//
//  ResultViewController.swift
//  beer-goggles
//
//  Created by Anton Lysov on 2018-04-04.
//  Copyright © 2018 Anton Lysov. All rights reserved.
//

import UIKit
import CoreML
import Vision
import ImageIO

class ViewController: UIViewController {

	var beerType: String! {
		didSet(value) {
			beerTypeLabel.text = "It's a \(value.capitalized)"
		}
	}
	@IBOutlet weak var welcomeLabel: UILabel!
	@IBOutlet weak var beerTypeLabel: UILabel!
	@IBOutlet weak var beerTypeImageView: UIImageView!
	@IBOutlet weak var randomBeerFactLabel: UILabel!
	@IBOutlet weak var tryAgainButton: UIButton!
	
	@IBAction func tryAgainButtonDidPress(_ sender: Any) {
		
		tryAgainButton.backgroundColor = UIColor(red:0.64, green:0.39, blue:0.19, alpha:1.0)
		// Show options for the source picker only if the camera is available.
		guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
			presentPhotoPicker(sourceType: .photoLibrary)
			return
		}
		
		let photoSourcePicker = UIAlertController()
		let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [unowned self] _ in
			self.presentPhotoPicker(sourceType: .camera)
		}
		let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { [unowned self] _ in
			self.presentPhotoPicker(sourceType: .photoLibrary)
		}
		
		photoSourcePicker.addAction(takePhoto)
		photoSourcePicker.addAction(choosePhoto)
		photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		present(photoSourcePicker, animated: true)
	}
	
	@IBAction func cameraButtonDidTouchDown(_ sender: Any) {
		tryAgainButton.backgroundColor = UIColor(red:0.44, green:0.28, blue:0.18, alpha:1.0)
	}
	
	func presentPhotoPicker(sourceType: UIImagePickerControllerSourceType) {
		let picker = UIImagePickerController()
		picker.delegate = self
		picker.sourceType = sourceType
		present(picker, animated: true)
	}
	
	// MARK: - Image Classification
	
	/// - Tag: MLModelSetup
	lazy var classificationRequest: VNCoreMLRequest = {
		do {
			/*
			Use the Swift class `MobileNet` Core ML generates from the model.
			To use a different Core ML classifier model, add it to the project
			and replace `MobileNet` with that model's generated Swift class.
			*/
			let model = try VNCoreMLModel(for: BeerClassifier().model)
			
			let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
				self?.processClassifications(for: request, error: error)
			})
			request.imageCropAndScaleOption = .centerCrop
			return request
		} catch {
			fatalError("Failed to load Vision ML model: \(error)")
		}
	}()
	
	/// - Tag: PerformRequests
	func updateClassifications(for image: UIImage) {
		beerTypeLabel.text = "Classifying..."
		print("Classifying...")
		
		let orientation = CGImagePropertyOrientation(image.imageOrientation)
		guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
		
		DispatchQueue.global(qos: .userInitiated).async {
			let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
			do {
				try handler.perform([self.classificationRequest])
			} catch {
				/*
				This handler catches general image processing errors. The `classificationRequest`'s
				completion handler `processClassifications(_:error:)` catches errors specific
				to processing that request.
				*/
				print("Failed to perform classification.\n\(error.localizedDescription)")
			}
		}
	}
	
	/// Updates the UI with the results of the classification.
	/// - Tag: ProcessClassifications
	func processClassifications(for request: VNRequest, error: Error?) {
		DispatchQueue.main.async {
			guard let results = request.results else {
				self.beerTypeLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
				print("Unable to classify image.\n\(error!.localizedDescription)")
				return
			}
			// The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
			let classifications = results as! [VNClassificationObservation]
			
			if classifications.isEmpty {
				self.beerTypeLabel.text = "Nothing recognized."
				print("Nothing recognized.")
			} else {
				// Display top classifications ranked by confidence in the UI.
				let guesses = classifications.map { classification in
					// Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
					return String(classification.identifier)
				}
				let descriptions = classifications.map { classification in
					// Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
					return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
				}
				
				switch guesses.first {
				case "ipa": self.beerTypeLabel.text = "It's IPA!"
				case "lager": self.beerTypeLabel.text = "It's Lager!"
				case "dark-ale": self.beerTypeLabel.text = "It's Dark-Ale!"
				default: self.beerTypeLabel.text = "Lager, I guess"
				}
				
				print("Classification:\n" + descriptions.joined(separator: "\n"))
			}
		}
	}
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	// MARK: - Handling Image Picker Selection
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
		
		picker.dismiss(animated: true)
		
		guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
			return
		}
		
		if beerTypeImageView.image == nil {
			// hide the old stuff
			welcomeLabel.isHidden = true
			
			// show the new stuff
			beerTypeLabel.isHidden = false
			beerTypeImageView.isHidden = false
			randomBeerFactLabel.isHidden = false
		}
		
		beerTypeImageView.image = image
		randomBeerFactLabel.text = BeerFact().random
		updateClassifications(for: image)
	}
}
