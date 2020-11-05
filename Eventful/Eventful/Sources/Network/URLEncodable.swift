//
//  URLEncodable.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/3/20.
//

protocol URLEncodable {
  func queryParameters() -> [String: String]
}
