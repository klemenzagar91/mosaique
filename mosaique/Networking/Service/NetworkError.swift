//
//  NetworkError.swift
//  mosaique
//
//  Created by Klemen Zagar on 29/03/2019.
//  Copyright © 2019 Klemen Zagar. All rights reserved.
//

import UIKit

public enum NetworkError: Error {
  
  // MARK: Error Reason Types
  
  /// Represents the error reason during networking request phase.
  ///
  public enum RequestErrorReason {
    //// Parameters in a URL request are nil. Code 1001
    ////
    case parametersNil
    
    //// Body or URL Parameters encoding failed. Code 1002
    ////
    case encodingFailed
    
    //// URL for the request is missing. Code 1003
    ////
    case missingURL
  }
  
  /// Represents the error reason during networking response phase.
  ///
  public enum ResponseErrorReason {
    
    //// Instead of response app receives error from the system network manager. Code 2001
    //// - error: URLSession errro
    case systemNetworkError(error: Error?)
    
    //// The response is successful but response data cannot be decoded. Code 2002
    //// - error: Decode error
    case unableToDecode(error: Error)
  }
  
  
  // MARK: Member Cases
  
  /// Represents the error reason during networking request phase.
  case requestError(reason: RequestErrorReason)
  /// Represents the error reason during networking response phase.
  case responseError(reason: ResponseErrorReason)
}




extension NetworkError.RequestErrorReason {
  var errorDescription: String? {
    switch self {
    case .parametersNil:
      return "Parameters in a URL request are nil."
    case .encodingFailed:
      return "Body or URL Parameters encoding failed.."
    case .missingURL:
      return "URL for the request is missing."
    }
  }
  
  var errorCode: Int {
    switch self {
    case .parametersNil:
      return 1001
    case .encodingFailed:
      return 1002
    case .missingURL:
      return 1003
    }
  }
}




extension NetworkError.ResponseErrorReason {
  var errorDescription: String? {
    switch self {
    case .systemNetworkError:
      return "Application received error from the system network manager."
    case .unableToDecode(let error):
      return "Application was unable to decode response data into object. Details: \(error.localizedDescription)"
    }
  }
  
  var errorCode: Int {
    switch self {
    case .systemNetworkError: return 2001
    case .unableToDecode: return 2002
    }
  }
}
