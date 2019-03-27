
//
//  PhotoViewModel.swift
//  mosaique
//
//  Created by Klemen Zagar on 22/03/2019.
//  Copyright © 2019 Klemen Zagar. All rights reserved.
//

import UIKit

class PhotoViewModel {
  let photo: Photo
  let apiManager: ApiManager
  let thumbnail: Observable<UIImage?> = Observable(nil)
  let image: Observable<UIImage?> = Observable(nil)
  
  
  
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
  }
  
  func fetchThumbnailIfNeeded() {
    if thumbnail.value == nil && !loadingThumbnail {
      loadingThumbnail = true
      apiManager.getImage(url: photo.thumbnailUrl) { [weak self] (image, error) in
        if let image = image {
          self?.loadingThumbnail = false
          self?.thumbnail.value = image
        }
      }
    }
  }
  
  
  func fetchImageIfNeeded() {
    if image.value == nil && !loadingImage {
      loadingImage = true
      apiManager.getImage(url: photo.url) { [weak self] (image, error) in
        if let image = image {
          self?.loadingImage = false
          self?.image.value = image
        }
      }
    }
  }
}
