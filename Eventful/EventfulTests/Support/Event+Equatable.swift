//
//  Event+Equatable.swift
//  EventfulTests
//
//  Created by Andrei Ahibalau on 11/5/20.
//

import Foundation
@testable import Eventful

extension Eventful.Event: Equatable {
  public static func == (lhs: Eventful.Event, rhs: Eventful.Event) -> Bool {
    lhs.identifier == rhs.identifier &&
      lhs.startDate == rhs.startDate &&
      lhs.title == rhs.title &&
      lhs.url == rhs.url
  }
}
