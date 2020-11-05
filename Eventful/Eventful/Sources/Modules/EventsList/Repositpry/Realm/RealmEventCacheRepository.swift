//
//  RealmEventCacheRepository.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/3/20.
//

import Foundation
import RxSwift
import RxCocoa
import RxRealm
import RealmSwift

class RealmEventCacheRepository: RealmFavoriteEventRepository, EventCacheRepository {
  static func cachedEventsRealm() throws -> Realm {
    try Realm(configuration: Realm.Configuration(
      fileURL: FileManager.default.url(
        for: .documentDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: true
      )
        .appendingPathComponent("CachedEventsData.realm"),
      deleteRealmIfMigrationNeeded: true))
  }

  var cacheDate: Observable<Date?> {
    guard let realm = try? Self.cachedEventsRealm() else { return .just(nil) }
    let cache = realm.objects(RealmEventsCache.self).first
    return .just(cache?.date)
  }

  var cachedEvents: Driver<[Event]> {
    do {
      let realm = try Self.cachedEventsRealm()
      let eventsCache = realm
        .objects(RealmEventsCache.self)
      let events = Observable.array(from: eventsCache)
        .map { $0.first?.events }
        .map { $0?.sorted(byKeyPath: "startDate") }
        .asDriver(onErrorJustReturn: nil)
      let favoriteEvents = self.favoriteEvents
        .map { Set(Array($0.map { $0.identifier }))}

      return Driver.combineLatest(
        events,
        favoriteEvents
      )
      .map { cachedEvents, favoriteEvents -> [Event] in
        guard let events = cachedEvents else { return [] }
        return events.map { $0.event }
          .map { event -> Event in
            var modifiedEvent = event
            modifiedEvent.isFavorite = favoriteEvents.contains(event.identifier)
            return modifiedEvent
          }
      }
    } catch {
      return .just([])
    }
  }

  func overrideCache(with events: [Event]) -> Observable<Void> {
    do {
      let realm = try Self.cachedEventsRealm()
      let newCache = RealmEventsCache()
      newCache.date = Date()
      newCache.events.append(objectsIn: events.map { RealmEventItem(event: $0) })

      return .just(try realm.write {
        realm.add(newCache, update: .all)
      })
    } catch {
      return .error(error)
    }
  }
}
