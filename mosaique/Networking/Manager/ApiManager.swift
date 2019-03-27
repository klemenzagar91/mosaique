//
//  NetworkManager.swift
//  NetworkLayer
//
//  Created by Malcolm Kumwenda on 2018/03/11.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import Foundation
import UIKit

enum NetworkResponse:String {
  case success
  case authenticationError = "You need to be authenticated first."
  case badRequest = "Bad request"
  case outdated = "The url you requested is outdated."
  case failed = "Network request failed."
  case noData = "Response returned with no data to decode."
  case unableToDecode = "We could not decode the response."
}

enum Result<String> {
  case success
  case failure(String)
}

class ApiManager {
  static let environment : NetworkEnvironment = .production
  let albumRouter = Router<AlbumApi>()
  
  func getAllAlbums(completion: @escaping ([Album]?, Error?) -> ()) {
    albumRouter.requestObject(.all) { (response, error) in
      completion(response, error)
    }
  }
  
  func getAllPhotos(albumId: AlbumId, completion: @escaping ([Photo]?, Error?) -> ()) {
    albumRouter.requestObject(.photos(albumId: albumId)) { (response, error) in
      completion(response, error)
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
