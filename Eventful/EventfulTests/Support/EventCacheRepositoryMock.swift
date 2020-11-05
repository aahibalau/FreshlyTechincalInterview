//
//  EventCacheRepositoryMock.swift
//  EventfulTests
//
//  Created by Andrei Ahibalau on 11/5/20.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
@testable import Eventful

class EventCacheRepositoryMock: RealmEventCacheRepository {
  func removeCache() {
    let realm = try! Self.cachedEventsRealm()
    try! realm.write {
      realm.deleteAll()
    }
  }

  func removeFavorites() {
    let realm = try! Self.favoriteEventsRealm()
    try! realm.write {
      realm.deleteAll()
    }
  }
}
