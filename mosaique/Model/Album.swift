//
//  Album.swift
//  mosaique
//
//  Created by Klemen Zagar on 19/03/2019.
//  Copyright © 2019 Klemen Zagar. All rights reserved.
//

import Foundation

public typealias AlbumId = Int

struct Album: Codable {
  let id: AlbumId
  let title: String
}
