//
//  AlbumViewModel.swift
//  mosaique
//
//  Created by Klemen Zagar on 21/03/2019.
//  Copyright © 2019 Klemen Zagar. All rights reserved.
//

import Foundation
import UIKit

typealias ErrorMessage = String

class AlbumsController {
  private var albums: [Album] = []
  private let apiManager: ApiManager
  
  let albumViewModels = Observable([AlbumViewModel]())
  let errorObserver: Observable<ErrorMessage?> = Observable(nil)
  
  
  init(with apiManager: ApiManager) {
    self.apiManager = apiManager
  }
  
  
  var albumCount: Int {
    return albumViewModels.value.count
  }
  
  func album(for index: Int) -> AlbumViewModel? {
    if albumViewModels.value.count > index {
      return albumViewModels.value[index]
    }
    return nil
  }
  
  func fetchData() {
    apiManager.getAllAlbums { [weak self] result in
      switch result {
      case .success(let albums):
        if let strongSelf = self {
          strongSelf.albums = albums
          strongSelf.albumViewModels.value = albums.map { AlbumViewModel(with: $0, apiManager: strongSelf.apiManager) }
        }
      case .failure(let error):
        self?.errorObserver.value = error.errorFrontEndDescription
      }
    }
  }
  
  func clearMemory() {
    albumViewModels.value.forEach {
      $0.clearMemory()
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
