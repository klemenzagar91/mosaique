//
//  AlbumViewController.swift
//  mosaique
//
//  Created by Klemen Zagar on 22/03/2019.
//  Copyright © 2019 Klemen Zagar. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  let cellId = "photoCellId"
  
  var albumViewModel: AlbumViewModel!
  var selectedCell: PhotoCell?
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.App.accent
    collectionView.backgroundColor = .clear
    collectionView.delegate = self
    collectionView.dataSource = self
    albumViewModel.photoViewModelsObserver.valueChanged = { [unowned self] photos in
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
    albumViewModel.errorObserver.valueChanged = { [weak self] errorMessage in
      DispatchQueue.main.async {
        if let message = errorMessage {
          self?.displayMessage(title: "Oh snap!", message: message)
        }
      }
    }
    albumViewModel.fetchPhotosIfNeeded()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
    title = albumViewModel.title.capitalizingFirstLetter()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  func displayMessage(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
}




extension AlbumViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return albumViewModel.photosCount
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoCell
    
    if let photo = albumViewModel.photo(for: indexPath.row) {
      cell.photoID = photo.photo.id
      photo.fetchThumbnailIfNeeded()
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if let cell = cell as? PhotoCell {
      if let photo = albumViewModel.photo(for: indexPath.row) {
        photo.thumbnail.valueChanged = { (thumbnail) in
          DispatchQueue.main.async {
            cell.imageView.image = thumbnail
          }
        }
        cell.imageView.image = photo.thumbnail.value
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if let photo = albumViewModel.photo(for: indexPath.row) {
      photo.thumbnail.valueChanged = nil
    }
  }
}




extension AlbumViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let totalHeight: CGFloat = 75.0
    let totalWidth: CGFloat = 75.0
    
    return CGSize(width: ceil(totalWidth), height: ceil(totalHeight))
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 2.0
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
      if let photo = albumViewModel.photo(for: indexPath.item), photo.thumbnail.value != nil || photo.image.value != nil {
        selectedCell = cell
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        if let photoVC = sb.instantiateViewController(withIdentifier: "PhotoViewController") as? PhotoViewController {
          photoVC.modalPresentationStyle = .overCurrentContext
          photoVC.transitioningDelegate = self
          photoVC.navigationDelegate = self
          photoVC.photoViewModel = photo
          present(photoVC, animated: true)
        }
      }
    }
  }
}




extension AlbumViewController: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController,
                           presenting: UIViewController,
                           source: UIViewController)
    -> UIViewControllerAnimatedTransitioning? {
      if let selectedCell = selectedCell {
        return PeekAnimationController(presenting: true, sourceTile: selectedCell.imageView)
      }
      return nil
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if let selectedCell = selectedCell {
      return PeekDismissAnimationController(finalView: selectedCell.imageView)
    }
    return nil
  }
}




extension AlbumViewController: Navigating {
  func shouldDismiss(_ vc: UIViewController) {
    dismiss(animated: true)
  }
}
