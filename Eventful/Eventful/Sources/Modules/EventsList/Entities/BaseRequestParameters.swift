//
//  BaseRequestParameters.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/5/20.
//

struct BaseRequestParameters: URLEncodable {
  let appKey: String

  func queryParameters() -> [String: String] {
    ["app_key": appKey]
  }
}
