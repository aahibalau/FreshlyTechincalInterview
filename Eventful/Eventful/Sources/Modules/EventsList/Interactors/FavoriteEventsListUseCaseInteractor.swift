//
//  FavoriteEventsListUseCaseInteractor.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/4/20.
//

import Foundation
import RxSwift
import RxCocoa

class FavoriteEventsListUseCaseInteractor: EventsListUseCase {

  let favoriteRepository: FavoriteEventRepository

  init(favoriteRepository: FavoriteEventRepository) {
    self.favoriteRepository = favoriteRepository
  }

  // MARK: - EventsListUseCase

  func loadEvents(with forceRefresh: Bool) -> Observable<Void> {
    .just(())
  }

  func events() -> Driver<[Event]> {
    favoriteRepository.favoriteEvents
  }

  func favorite(event: Event) -> Observable<Void> {
    favoriteRepository.favorite(event: event)
  }

  func unfavorite(event: Event) -> Observable<Void> {
    favoriteRepository.unfavorite(event: event)
  }
}


