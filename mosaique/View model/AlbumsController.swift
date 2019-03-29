//
//  AlbumViewModel.swift
//  mosaique
//
//  Created by Klemen Zagar on 21/03/2019.
//  Copyright © 2019 Klemen Zagar. All rights reserved.
//

import Foundation
import UIKit

class AlbumsController {
  private var albums: [Album] = []
  private let apiManager: ApiManager
  
  let albumViewModels = Observable([AlbumViewModel]())
  
  
  
  
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
    apiManager.getAllAlbums { [weak self] (albums, error) in
      if let albums = albums, let strongSelf = self {
        strongSelf.albums = albums
        strongSelf.albumViewModels.value = albums.map { AlbumViewModel(with: $0, apiManager: strongSelf.apiManager) }
      }
    }
  }
  
  func clearMemory() {
    albumViewModels.value.forEach {
      $0.clearMemory()
    }
  }
}
