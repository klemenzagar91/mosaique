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

