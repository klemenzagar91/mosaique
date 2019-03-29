//
//  Observable.swift
//  mosaique
//
//  Created by Klemen Zagar on 25/03/2019.
//  Copyright © 2019 Klemen Zagar. All rights reserved.
//

import Foundation

class Observable<T> {
  var value: T {
    didSet {
      valueChanged?(value)
    }
  }
  var valueChanged: ((T) -> Void)?
  
  init(_ value: T) {
    self.value = value
  }
}
