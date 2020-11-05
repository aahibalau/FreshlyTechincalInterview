//
//  RealmFavoriteEventRepository.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/3/20.
//

import Foundation
import RxSwift
import RxCocoa
import RxRealm
import RealmSwift

class RealmFavoriteEventRepository: FavoriteEventRepository {
  static func favoriteEventsRealm() throws -> Realm {
    try Realm(configuration: Realm.Configuration(
      fileURL: FileManager.default.url(
        for: .documentDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: true
      )
        .appendingPathComponent("FavoriteEventsData.realm"),
      deleteRealmIfMigrationNeeded: true))
  }

  var favoriteEvents: Driver<[Event]> {
    do {
      let realm = try Self.favoriteEventsRealm()
      let events = realm
        .objects(RealmEventItem.self)
        .sorted(byKeyPath: "startDate")
      return Observable.array(from: events)
        .map { $0.map { $0.event }}
        .asDriver(onErrorJustReturn: [])
    } catch {
      print("Realm error", error.localizedDescription)
      return .just([])
    }
  }

  func favorite(event: Event) -> Observable<Void> {
    do {
      let realm = try Self.favoriteEventsRealm()
      let eventObject = RealmEventItem(event: event)
      eventObject.isFavorite = true
      return .just(try realm.write {
        realm.add(eventObject, update: .modified)
      })
    } catch {
      return .error(error)
    }
  }

  func unfavorite(event: Event) -> Observable<Void> {
    do {
      let realm = try Self.favoriteEventsRealm()
      let eventObject = realm.object(
        ofType: RealmEventItem.self,
        forPrimaryKey: event.identifier)
      return .just(try realm.write {
        eventObject.map { realm.delete($0) }
      })
    } catch {
      return .error(error)
    }
  }
}
