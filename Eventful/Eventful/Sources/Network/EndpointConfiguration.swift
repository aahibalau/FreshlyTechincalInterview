//
//  EndpointConfiguration.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/3/20.
//

protocol EndpointConfiguration {
  var path: String { get }
  var method: Method { get }
}

enum Method: String {
  case get = "GET"
}
