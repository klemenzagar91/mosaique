//
//  Result.swift
//  mosaique
//
//  Created by Klemen Zagar on 29/03/2019.
//  Copyright © 2019 Klemen Zagar. All rights reserved.
//

import Foundation


enum Result<T> {
  case success(T)
  case failure(NetworkError)
}
