//
//  AlbumEndPoint.swift
//  mosaique
//
//  Created by Klemen Zagar on 20/03/2019.
//  Copyright © 2019 Klemen Zagar. All rights reserved.
//

import Foundation


public enum AlbumApi {
  case all
  case photos(albumId:Int)
  case image(url: String)
}

extension AlbumApi: EndPointType {
  
  var environmentBaseURL : String {
    switch ApiManager.environment {
    case .production: return "https://jsonplaceholder.typicode.com/"
    case .staging: return "https://jsonplaceholder.typicode.com/"
    }
  }
  
  var baseURL: URL {
    switch self {
    case .image(let urlString):
      guard let url = URL(string: urlString) else { fatalError("baseURL could not be configured.")}
      return url
    default:
      guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
      return url
    }
  }
  
  var path: String {
    switch self {
    case .all:
      return "albums"
    case .photos(_):
      return "photos"
    case .image(_):
      return ""
    }
  }
  
  var httpMethod: HTTPMethod {
    return .get
  }
  
  var task: HTTPTask {
    switch self {
    case .all:
      return .request
    case .photos(let albumId):
      return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: ["albumId": albumId])
    case .image(let urlString):
      return .downloadImage(url: urlString)
    }
  }
  
  var headers: HTTPHeaders? {
    return nil
  }
}


