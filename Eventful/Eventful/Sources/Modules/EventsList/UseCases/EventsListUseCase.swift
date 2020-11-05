//
//  EventsListUseCase.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/3/20.
//

import RxSwift
import RxCocoa

protocol EventsListUseCase {
  func loadEvents(with forceRefresh: Bool) -> Observable<Void>
  func events() -> Driver<[Event]>
  func favorite(event: Event) -> Observable<Void>
  func unfavorite(event: Event) -> Observable<Void>
}
