//
//  RealmEventItem.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/3/20.
//

import Foundation
import RealmSwift

class RealmEventItem: Object {
  @objc dynamic var identifier = ""
  @objc dynamic var title = ""
  @objc dynamic var url = ""
  @objc dynamic var startDate = Date.init(timeIntervalSince1970: 0)
  @objc dynamic var isFavorite = false

  override class func primaryKey() -> String? { "identifier" }
}

extension RealmEventItem {
  convenience init(event: Event) {
    self.init()
    identifier = event.identifier
    title = event.title
    url = event.url
    startDate = event.startDate
  }

  var event: Event {
    Event(
      identifier: identifier,
      title: title,
      url: url,
      startDate: startDate,
      isFavorite: isFavorite)
  }
}
