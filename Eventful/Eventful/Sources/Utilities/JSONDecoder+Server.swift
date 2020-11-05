//
//  JSONDecoder+Server.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/4/20.
//

import Foundation

extension DateFormatter {
  static let serverDateTimeNoLocale: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.timeZone = TimeZone.current
    return formatter
  }()
}

extension JSONDecoder {
  static func server() -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(.serverDateTimeNoLocale)
    return decoder
  }
}
