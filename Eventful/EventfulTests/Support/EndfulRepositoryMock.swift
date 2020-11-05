//
//  EndfulRepositoryMock.swift
//  EventfulTests
//
//  Created by Andrei Ahibalau on 11/5/20.
//

import Foundation
import RxSwift
@testable import Eventful

class EndfulRepositoryMock: EndfulRepository {

  var waitTime: Int = 0
  var events: [Eventful.Event] = []

  func searchEvents() -> Observable<[Eventful.Event]> {
    guard waitTime > 0 else {
      return .just(events)
    }
    let events = self.events
    return Observable.just(())
      .delay(.seconds(waitTime), scheduler: MainScheduler.instance)
      .map { _ in events }
  }
}
