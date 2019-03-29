
//
//  PhotoViewModel.swift
//  mosaique
//
//  Created by Klemen Zagar on 22/03/2019.
//  Copyright © 2019 Klemen Zagar. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoViewModel {
  let photo: Photo
  let apiManager: ApiManager
  let thumbnail: Observable<UIImage?> = Observable(nil)
  let image: Observable<UIImage?> = Observable(nil)
  let id: Int
  
  
  var bestPossiblePhoto: UIImage? {
    if image.value != nil {
      return image.value
    } else if thumbnail.value != nil {
      return thumbnail.value
    }
    return nil
  }
  var loadingThumbnail = false
  var loadingImage = false
  
  
  
  
  init(with photo: Photo, apiManager: ApiManager) {
    self.apiManager = apiManager
    self.photo = photo
    id = photo.id
  }
  
  func fetchThumbnailIfNeeded() {
    if thumbnail.value == nil && !loadingThumbnail {
      loadingThumbnail = true
      KingfisherManager.shared.retrieveImage(with: URL(string: photo.thumbnailUrl)!) { [weak self] result in
        switch result {
        case .success(let value):
          self?.loadingThumbnail = false
          self?.thumbnail.value = value.image
        case .failure(let error):
          print("image couldn't be loaded \(error.localizedDescription)")
        }
      }
    }
  }
  
  
  func fetchImageIfNeeded() {
    if image.value == nil && !loadingImage {
      loadingImage = true
      KingfisherManager.shared.retrieveImage(with: URL(string: photo.url)!) { [weak self] result in
        switch result {
        case .success(let value):
          self?.loadingImage = false
          self?.image.value = value.image
        case .failure(let error):
          print("image couldn't be loaded \(error.localizedDescription)")
        }
      }
    }
  }
  
  func clearMemory() {
    thumbnail.value = nil
    image.value = nil
  }
}
