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
}




extension AlbumViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return albumViewModel.photosCount
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoCell
    
    if let photo = albumViewModel.photo(for: indexPath.row) {
      cell.photoID = photo.photo.id
      cell.imageView.image = photo.thumbnail.value
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
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        if let photoVC = sb.instantiateViewController(withIdentifier: "PhotoViewController") as? PhotoViewController {
          photoVC.modalTransitionStyle = .coverVertical
          photoVC.modalPresentationStyle = .overCurrentContext
          photoVC.photoViewModel = photo
          present(photoVC, animated: true)
        }
      }
    }
  }
}

