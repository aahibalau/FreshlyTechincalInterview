//
//  RealmEventCache.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/3/20.
//

import Foundation
import RealmSwift

class RealmEventsCache: Object {
  @objc dynamic var singleValue = "Single"
  @objc dynamic var date = Date(timeIntervalSince1970: 0)
  let events = List<RealmEventItem>()
  
  override class func primaryKey() -> String? { "singleValue" }
}
