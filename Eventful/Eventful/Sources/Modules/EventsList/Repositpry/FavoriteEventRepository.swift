//
//  FavoriteEventRepository.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/3/20.
//

import Foundation
import RxSwift
import RxCocoa

protocol FavoriteEventRepository {
  func favorite(event: Event) -> Observable<Void>
  func unfavorite(event: Event) -> Observable<Void>
  var favoriteEvents: Driver<[Event]> { get }
}
