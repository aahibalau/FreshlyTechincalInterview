//
//  EventsListUseCaseInteractor.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/3/20.
//

import Foundation
import RxSwift
import RxCocoa

class EventsListUseCaseInteractor: EventsListUseCase {
  enum Constant {
    static let cacheTime: TimeInterval = 3600
  }

  let remoteRepository: EndfulRepository
  let localRepository: EventCacheRepository

  init(remoteRepository: EndfulRepository, localRepository: EventCacheRepository) {
    self.remoteRepository = remoteRepository
    self.localRepository = localRepository
  }

  private func loadEventsAndCache() -> Observable<Void> {
    remoteRepository.searchEvents()
      .flatMapLatest { [weak self] in
        self?.localRepository.overrideCache(with: $0) ?? .empty()
      }
  }

  // MARK: - EventsListUseCase

  func loadEvents(with forceRefresh: Bool) -> Observable<Void> {
    localRepository.cacheDate
      .flatMapLatest { [weak self] eventDate -> Observable<Void> in
        guard let eventDate = eventDate,
              abs(eventDate.timeIntervalSince(Date())) < Constant.cacheTime,
              !forceRefresh else {
          return self?.loadEventsAndCache() ?? .empty()
        }
        return .just(())
      }
  }

  func events() -> Driver<[Event]> {
    localRepository.cachedEvents
  }

  func favorite(event: Event) -> Observable<Void> {
    localRepository.favorite(event: event)
  }

  func unfavorite(event: Event) -> Observable<Void> {
    localRepository.unfavorite(event: event)
  }
}
