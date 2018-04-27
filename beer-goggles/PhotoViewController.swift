//
//  PhotoViewController.swift
//  beer-goggles
//
//  Created by Anton Lysov on 2018-04-04.
//  Copyright © 2018 Anton Lysov. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

	var takenPhoto: UIImage?
	
	@IBOutlet weak var imageView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let availableImage = takenPhoto {
			imageView.image = availableImage
		}
	}
	
	@IBAction func goBack(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
}
