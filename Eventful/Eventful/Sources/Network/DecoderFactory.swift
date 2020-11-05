//
//  DecoderFactory.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/3/20.
//

import Foundation

enum DecoderFactory {
  static func apiJsonDecodeFunction<ResponseObject: Decodable>(
    with decoder: JSONDecoder
  ) -> (Data) throws -> ResponseObject {
    { (data: Data) throws -> ResponseObject in
      try decoder.decode(ResponseObject.self, from: data)
    }
  }
}
