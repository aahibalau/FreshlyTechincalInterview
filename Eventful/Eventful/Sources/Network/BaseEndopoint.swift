//
//  BaseEndopoint.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/3/20.
//

import Foundation

struct BaseEndopoint<RequestParameters, Response>: Endpoint {
  let configuration: EndpointConfiguration
  let parameters: RequestParameters

  let encoder: (inout URLRequest, RequestParameters) throws -> Void
  let decoder: (Data) throws -> Response

  func encode(reqeust: inout URLRequest) throws {
    guard let baseUrl = reqeust.url,
      let pathUrl = URL(string: configuration.path, relativeTo: baseUrl) else {
      throw EncodeError.emptyUrl
    }
    reqeust.url = pathUrl
    try encoder(&reqeust, parameters)
  }

  func decode(data: Data) throws -> Response {
    try decoder(data)
  }
}
