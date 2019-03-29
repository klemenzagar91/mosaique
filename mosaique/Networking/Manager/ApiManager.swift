//
//  ApiManager.swift
//  mosaique
//
//  Created by Klemen Zagar on 29/03/2019.
//  Copyright © 2019 Klemen Zagar. All rights reserved.
//

import Foundation
import UIKit


enum NetworkEnvironment {
  case production
  case staging
}


class ApiManager {
  static let environment : NetworkEnvironment = .production
  let albumRouter = Router<AlbumApi>()
  
  func getAllAlbums(completion: @escaping (Result<[Album]>) -> ()) {
    albumRouter.requestObject(.all) { result in
      completion(result)
    }
  }
  
  func getAllPhotos(albumId: AlbumId, completion: @escaping (Result<[Photo]>) -> ()) {
    albumRouter.requestObject(.photos(albumId: albumId)) { result in
      completion(result)
    }
  }
  
  func getImage(url: String, completion: @escaping (UIImage?, Error?) -> ()) {
    albumRouter.request(.image(url: url)) { (data, response, error) in
      guard let responseData = data else {
        completion(nil, error)
        return
      }
      completion(UIImage(data: responseData), error)
    }
  }
  
}
