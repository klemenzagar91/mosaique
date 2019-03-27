//
//  AlbumViewModel.swift
//  mosaique
//
//  Created by Klemen Zagar on 22/03/2019.
//  Copyright © 2019 Klemen Zagar. All rights reserved.
//

import Foundation
import UIKit

class AlbumViewModel {
  let album: Album
  let title: String
  let firstPreviewObserver: Observable<PhotoViewModel?> = Observable(nil)
  let firstPreviewImageObserver: Observable<UIImage?> = Observable(nil)
  
  
  private var firstPreview: PhotoViewModel? {
    didSet {
      firstPreviewObserver.value = firstPreview
      firstPreview?.image.valueChanged = { [weak self] (image) in
        self?.firstPreviewImageObserver.value = image
      }
    }
  }
  let secondPreviewObserver: Observable<PhotoViewModel?> = Observable(nil)
  let secondPreviewImageObserver: Observable<UIImage?> = Observable(nil)
  var secondPreview: PhotoViewModel? {
    didSet {
      secondPreviewObserver.value = secondPreview
      secondPreview?.image.valueChanged = { [weak self] (image) in
        self?.secondPreviewImageObserver.value = image
      }
    }
  }
  let apiManager: ApiManager
  
  private var fetched = false
  private var isFetchingAlbums = false
  
  private var photos: [Photo] = []
  let photoViewModelsObserver = Observable([PhotoViewModel]())
  private var photoViewModels = [PhotoViewModel]() {
    didSet {
      setupPreviews()
      photoViewModelsObserver.value = photoViewModels
    }
  }

  var photosCountSubtitle: String {
    return String(photoViewModels.count) + " " + (photoViewModels.count == 1 ? "photo" : "photos")
  }
  
  
  init(with album: Album, apiManager: ApiManager) {
    self.apiManager = apiManager
    self.album = album
    title = album.title
  }
  
  
  func setupPreviews() {
    if photoViewModels.count > 1 {
      firstPreview = photoViewModels[0]
      secondPreview = photoViewModels[1]
    }
  }
  
  func photo(for index: Int) -> PhotoViewModel? {
    if photoViewModels.count > index {
      return photoViewModels[index]
    }
    return nil
  }
  
  var photosCount: Int {
    return photoViewModels.count
  }
  
  var albumId: AlbumId {
    return album.id
  }
  
  func fetchPhotosIfNeeded() {
    if !fetched && !isFetchingAlbums {
      isFetchingAlbums = true
      apiManager.getAllPhotos(albumId: album.id) { [weak self] (photos, error) in
        self?.isFetchingAlbums = false
        if let photos = photos, let strongSelf = self {
          strongSelf.fetched = true
          strongSelf.photos = photos
          strongSelf.photoViewModels = photos.map { PhotoViewModel(with: $0, apiManager: strongSelf.apiManager) }
        } else {
          print("error fetching for \(self?.album.id)")
        }
      }
    }
  }
  
  func fetchPreviewImagesIfNeeded() {
    firstPreview?.fetchImageIfNeeded()
    secondPreview?.fetchImageIfNeeded()
  }
}


