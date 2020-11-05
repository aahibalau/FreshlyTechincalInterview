//
//  Endpoint.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/3/20.
//

import Foundation

protocol Endpoint {
  associatedtype Response

  var configuration: EndpointConfiguration { get }

  func encode(reqeust: inout URLRequest) throws
  func decode(data: Data) throws -> Response
}
