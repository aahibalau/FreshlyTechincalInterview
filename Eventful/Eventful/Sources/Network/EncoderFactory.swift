//
//  EncoderFactory.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/3/20.
//

import Foundation

enum EncodeError: Error {
  case emptyUrl
}

enum EncoderFactory {
  static func urlEncodeFunction<Parameters: URLEncodable>(
  ) -> (inout URLRequest, Parameters) throws -> Void {
    { (request: inout URLRequest, parameters: Parameters) throws in
      guard let url = request.url,
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
        throw EncodeError.emptyUrl
      }
      let requestParameters = parameters.queryParameters()
        .map { URLQueryItem(name: $0.key, value: $0.value) }
      components.queryItems = requestParameters
      request.url = components.url
    }
  }
}
