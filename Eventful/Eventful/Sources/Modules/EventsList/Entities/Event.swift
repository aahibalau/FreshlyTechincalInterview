//
//  Event.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/2/20.
//

import Foundation

struct Event: Decodable {
  let identifier: String
  let title: String
  let url: String
  let startDate: Date

  var isFavorite: Bool = false

  enum CodingKeys: String, CodingKey {
    case identifier = "id"
    case title
    case url
    case startDate = "start_time"
  }
}
