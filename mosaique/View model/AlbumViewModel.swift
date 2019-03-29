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
  let apiManager: ApiManager
  
  private var photos: [Photo] = []
  let photoViewModelsObserver = Observable([PhotoViewModel]())
  private var photoViewModels = [PhotoViewModel]() {
    didSet {
      setupPreviews()
      photoViewModelsObserver.value = photoViewModels
    }
  }
  
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
  
  let errorObserver: Observable<ErrorMessage?> = Observable(nil)
  
  
  
  private var fetched = false
  private var isFetchingAlbums = false

  
  
  
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
  
  var photosCountSubtitle: String {
    return String(photoViewModels.count) + " " + (photoViewModels.count == 1 ? "photo" : "photos")
  }
  
  func fetchPhotosIfNeeded() {
    if !fetched && !isFetchingAlbums {
      isFetchingAlbums = true
      apiManager.getAllPhotos(albumId: album.id) { [weak self] result in
        self?.isFetchingAlbums = false
        switch result {
        case .success(let photos):
          if let strongSelf = self {
            strongSelf.fetched = true
            strongSelf.photos = photos
            strongSelf.photoViewModels = photos.map { PhotoViewModel(with: $0, apiManager: strongSelf.apiManager) }
          }
        case .failure(let error):
          self?.errorObserver.value = error.errorFrontEndDescription
        }
      }
    }
  }
  
  func fetchPreviewImagesIfNeeded() {
    firstPreview?.fetchImageIfNeeded()
    secondPreview?.fetchImageIfNeeded()
  }
  
  func clearMemory() {
    let firstPreviewId = firstPreview?.id ?? -1
    let secondPreviewId = secondPreview?.id ?? -1
    
    photoViewModels.forEach {
      let doesMatchWithPreviews = $0.id == firstPreviewId || $0.id == secondPreviewId
      if !doesMatchWithPreviews {
        $0.clearMemory()
      }
    }
  }
}


private extension NetworkError {
  var errorFrontEndDescription: ErrorMessage {
    switch self {
    case .requestError(let reason):
      switch reason {
      case .parametersNil, .encodingFailed, .missingURL:
        return "Cannot retrieve any data"
      }
    case .responseError(let reason):
      switch reason {
      case .systemNetworkError, .unableToDecode:
        return "Cannot retrieve any data"
      }
    }
  }
}

