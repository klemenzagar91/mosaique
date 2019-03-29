//
//  PhotoViewController.swift
//  mosaique
//
//  Created by Klemen Zagar on 23/03/2019.
//  Copyright © 2019 Klemen Zagar. All rights reserved.
//

protocol Navigating: class {
  func shouldDismiss(_ vc: UIViewController)
}

import UIKit

class PhotoViewController: UIViewController {
  @IBOutlet weak var photoView: UIImageView!
  @IBOutlet weak var photoTitleContainer: UIView!
  @IBOutlet weak var photoTitleLabel: UILabel!
  @IBOutlet weak var closeButton: AppButton!
  @IBOutlet weak var backgroundView: UIVisualEffectView!
  @IBOutlet weak var contentContainerView: UIView!
  
  var photoViewModel: PhotoViewModel!
  weak var navigationDelegate: Navigating?
  
  
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
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  
  func updateUI() {
    UIView.transition(with: photoView,
                      duration: 0.25,
                      options: [.allowAnimatedContent, .transitionCrossDissolve],
                      animations: { [weak self] in
                        self?.photoView.image = self?.photoViewModel.bestPossiblePhoto
                        
    })
    
    photoTitleLabel.text = photoViewModel.photo.title.capitalizingFirstLetter()
  }
  
  @IBAction func handleCloseAction(_ sender: UIButton) {
    navigationDelegate?.shouldDismiss(self)
  }
}



extension PhotoViewController: PeekTransition {
  func transitionBackground() -> UIView {
    return backgroundView
  }
  
  func transitionContentView() -> UIView {
    return contentContainerView
  }
  
  func peekView() -> UIView {
    return photoView
  }
  
  func headerview() -> UIView {
    return photoTitleContainer
  }
}
