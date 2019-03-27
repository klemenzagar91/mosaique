
//
//  Response.swift
//  mosaique
//
//  Created by Klemen Zagar on 24/03/2019.
//  Copyright © 2019 Klemen Zagar. All rights reserved.
//

import UIKit


struct Resource {
  static func parse<A: Decodable>(_ data: Data, into type: A.Type) -> A? {
    return try? JSONDecoder().decode(type, from: data)
  }
  
  static func decodeImage(from data: Data) -> UIImage? {
    return UIImage(data: data)
  }
}

//struct Response<T> {
//  func decode(data: Data) -> T? {
//    if let codable = T.self as? Decodable {
//      let jsonDecoder = JSONDecoder()
//      do {
//        let response = try jsonDecoder.decode(T, from: data)
//        return response
//      } catch _ {
//        return nil
//      }
//    }
//    return nil
//  }
//}
//public enum ResponseDecoding {
//  case jsonDecoding
//  case imageDecoding
//}
//struct Response<T> {
//  let decoding: ResponseDecoding
//
//  public func decode(data: Data) -> T? {
//    switch decoding {
//    case .jsonDecoding:
//      let jsonDecoder = JSONDecoder()
//      if T is Decodable {
//
//      }
//      do {
//        let response = try jsonDecoder.decode(T, from: data)
//        return response
//      } catch _ {
//        return nil
//      }
//    case .imageDecoding:
//      return UIImage(data: data)
//    }
//  }
//}



//
//extension Response {
//  public func decode<T: Decodable>(_ type: T.Type) -> T? {
//    let jsonDecoder = JSONDecoder()
//    do {
//      let response = try jsonDecoder.decode(T.self, from: data)
//      return response
//    } catch _ {
//      return nil
//    }
//  }
//}
