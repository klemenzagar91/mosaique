//
//  Helper.swift
//  mosaique
//
//  Created by Klemen Zagar on 23/03/2019.
//  Copyright © 2019 Klemen Zagar. All rights reserved.
//

import Foundation

extension String {
  func capitalizingFirstLetter() -> String {
    return prefix(1).capitalized + dropFirst()
  }
  
  mutating func capitalizeFirstLetter() {
    self = self.capitalizingFirstLetter()
  }
}
