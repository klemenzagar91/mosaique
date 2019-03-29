
//
//  Response.swift
//  mosaique
//
//  Created by Klemen Zagar on 24/03/2019.
//  Copyright © 2019 Klemen Zagar. All rights reserved.
//

import UIKit


struct Resource {
  static func parse<A: Decodable>(_ data: Data, into type: A.Type) throws -> A  {
    do {
      return try JSONDecoder().decode(type, from: data)
    }
    catch {
      throw error
    }
  }
  
  static func decodeImage(from data: Data) -> UIImage? {
    return UIImage(data: data)
  }
}
