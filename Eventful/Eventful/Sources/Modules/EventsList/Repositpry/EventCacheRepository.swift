//
//  EventCacheRepository.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/3/20.
//

import Foundation
import RxSwift
import RxCocoa

protocol EventCacheRepository: FavoriteEventRepository {
  var cacheDate: Observable<Date?> { get }
  var cachedEvents: Driver<[Event]> { get }
  func overrideCache(with events: [Event]) -> Observable<Void>
}
