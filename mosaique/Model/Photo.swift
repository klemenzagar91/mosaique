//
//  Photo.swift
//  mosaique
//
//  Created by Klemen Zagar on 19/03/2019.
//  Copyright © 2019 Klemen Zagar. All rights reserved.
//

import Foundation

struct Photo: Codable {
  let albumId: AlbumId
  let id: Int
  let title: String
  let url: String
  let thumbnailUrl: String
}
