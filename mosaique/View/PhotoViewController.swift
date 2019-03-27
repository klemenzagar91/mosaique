//
//  PhotoViewController.swift
//  mosaique
//
//  Created by Klemen Zagar on 23/03/2019.
//  Copyright © 2019 Klemen Zagar. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
  @IBOutlet weak var photoView: UIImageView!
  @IBOutlet weak var photoTitleContainer: UIView!
  @IBOutlet weak var photoTitleLabel: UILabel!
  @IBOutlet weak var closeButton: AppButton!
  @IBOutlet weak var backgroundView: UIVisualEffectView!
  
  var photoViewModel: PhotoViewModel!
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.isOpaque = false
    view.backgroundColor = .clear
    photoTitleContainer.layer.cornerRadius = 5.0
    photoView.layer.cornerRadius = 5.0
    photoView.clipsToBounds = true
    closeButton.heightClass = .compact
    closeButton.isShady = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let effect = UIBlurEffect(style: .light)
    backgroundView.effect = effect
    
    photoViewModel.image.valueChanged = { [weak self] (fullResolutionPhoto) in
      DispatchQueue.main.async {
        self?.updateUI()
      }
    }
    photoViewModel.fetchImageIfNeeded()
    updateUI()
  }
  
  
  func updateUI() {
    photoView.image = photoViewModel.bestPossiblePhoto
    photoTitleLabel.text = photoViewModel.photo.title.capitalizingFirstLetter()
  }
  
  @IBAction func handleCloseAction(_ sender: UIButton) {
    dismiss(animated: true)
  }
}
