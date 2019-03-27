//
//  AlbumsViewController.swift
//  mosaique
//
//  Created by Klemen Zagar on 20/03/2019.
//  Copyright © 2019 Klemen Zagar. All rights reserved.
//

import UIKit

class AlbumsViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  private let refreshControl = UIRefreshControl()
  var albumsController: AlbumsController!
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.App.accent
    setupTableView()
    
    albumsController.albumViewModels.valueChanged = { [weak self] (albums) in
      DispatchQueue.main.async {
        self?.tableView.reloadData()
        self?.refreshControl.endRefreshing()
      }
    }
    albumsController.fetchData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
    deselectTableRow()
    albumsController.clearMemory()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    albumsController.clearMemory()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  
  func deselectTableRow() {
    if let selectedIndexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: selectedIndexPath, animated: true)
    }
  }
  
  func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none;
    tableView.estimatedRowHeight = 250.0;
    tableView.rowHeight = UITableView.automaticDimension;
    tableView.indicatorStyle = .white
    tableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(refreshTableHandler(_:)), for: .valueChanged)
  }
  
  func removeModelObservers(for album: AlbumViewModel) {
    album.photoViewModelsObserver.valueChanged = nil
    album.firstPreviewObserver.valueChanged = nil
    album.secondPreviewObserver.valueChanged = nil
    album.firstPreviewImageObserver.valueChanged = nil
    album.secondPreviewImageObserver.valueChanged = nil
  }
  
  
  // MARK: - User events
  @objc private func refreshTableHandler(_ sender: Any) {
    albumsController.fetchData()
  }
}




extension AlbumsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let album = albumsController.album(for: indexPath.row) {
      let sb = UIStoryboard.init(name: "Main", bundle: nil)
      if let albumVC = sb.instantiateViewController(withIdentifier: "AlbumViewController") as? AlbumViewController {
        albumVC.albumViewModel = album
        navigationController?.pushViewController(albumVC, animated: true)
      }
    }
  }
}




extension AlbumsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return albumsController.albumCount > 0 ? albumsController.albumCount : 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "albumCellID", for: indexPath) as! AlbumPreviewCell
    
    if let album = albumsController.album(for: indexPath.row) {
      cell.assign(modelIdentifier: album.albumId)
      album.fetchPhotosIfNeeded()
      album.fetchPreviewImagesIfNeeded()
    } else {
      cell.reset()
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if let cell = cell as? AlbumPreviewCell {
      if let album = albumsController.album(for: indexPath.row) {
        cell.setup(for: album)
        album.firstPreviewObserver.valueChanged = { preview in
          preview?.fetchImageIfNeeded()
          DispatchQueue.main.async {
          }
        }
        album.secondPreviewObserver.valueChanged = { preview in
          preview?.fetchImageIfNeeded()
          DispatchQueue.main.async {
          }
        }
      }
    }
  }
  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if let album = albumsController.album(for: indexPath.row) {
      removeModelObservers(for: album)
    }
  }
}



