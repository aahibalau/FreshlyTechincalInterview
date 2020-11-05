//
//  EventsListUseCaseInteractorTests.swift
//  EventfulTests
//
//  Created by Andrei Ahibalau on 11/5/20.
//

import XCTest
import RxSwift
import RxBlocking
import RxTest
@testable import Eventful

class EventsListUseCaseInteractorTests: XCTestCase {

  var remoteRepository: EndfulRepositoryMock!
  var cacheRepository: EventCacheRepositoryMock!
  var disposeBag: DisposeBag!
  var scheduler: TestScheduler!

  var event1: Eventful.Event!
  var event2: Eventful.Event!

  override func setUpWithError() throws {
    remoteRepository = EndfulRepositoryMock()
    cacheRepository = EventCacheRepositoryMock()
    cacheRepository.removeCache()
    cacheRepository.removeFavorites()
    disposeBag = DisposeBag()
    scheduler = TestScheduler(initialClock: 0)
    event1 = Eventful.Event(
      identifier: "1", title: "1", url: "url1", startDate: Date(timeIntervalSinceNow: -100))
    event2 = Eventful.Event(
      identifier: "2", title: "2", url: "url2", startDate: Date(timeIntervalSinceNow: 100))
  }

  func testLoadEvents() throws {
    let sut = EventsListUseCaseInteractor(
      remoteRepository: remoteRepository,
      localRepository: cacheRepository)
    remoteRepository.events = [event1, event2]

    let loading = scheduler.createObserver(Void.self)
    sut.loadEvents(with: false).bind(to: loading).disposed(by: disposeBag)

    switch loading.events.first?.value {
    case .next(()): break
    default: XCTFail("Events not loaded")
    }
  }

  func testLoadEventsWithEmptyCache() throws {
    let sut = EventsListUseCaseInteractor(
      remoteRepository: remoteRepository,
      localRepository: cacheRepository)
    remoteRepository.events = [event1, event2]

    let loading = scheduler.createObserver(Void.self)
    let events = scheduler.createObserver([Eventful.Event].self)

    sut.loadEvents(with: false)
      .bind(to: loading)
      .disposed(by: disposeBag)
    sut.events()
      .drive(events)
      .disposed(by: disposeBag)


    XCTAssertEqual(
      events.events,
      [.next(0, [event1, event2])])
  }

  func testLoadEventsWithCacheWithoutForceReload() throws {
    let sut = EventsListUseCaseInteractor(
      remoteRepository: remoteRepository,
      localRepository: cacheRepository)
    remoteRepository.events = [event1, event2]
    _ = cacheRepository.overrideCache(with: [event1])

    let loading = scheduler.createObserver(Void.self)
    let events = scheduler.createObserver([Eventful.Event].self)

    sut.events().drive(events).disposed(by: disposeBag)
    sut.loadEvents(with: false).bind(to: loading).disposed(by: disposeBag)
    sut.events().drive(events).disposed(by: disposeBag)

    XCTAssertEqual(events.events, [.next(0, [event1]), .next(0, [event1])])
  }

  func testLoadEventsWithCacheWithForceReload() throws {
    let sut = EventsListUseCaseInteractor(
      remoteRepository: remoteRepository,
      localRepository: cacheRepository)
    remoteRepository.events = [event1, event2]
    _ = cacheRepository.overrideCache(with: [event1])

    let loading = scheduler.createObserver(Void.self)
    let events = scheduler.createObserver([Eventful.Event].self)

    sut.events().drive(events).disposed(by: disposeBag)
    sut.loadEvents(with: true).bind(to: loading).disposed(by: disposeBag)
    sut.events().drive(events).disposed(by: disposeBag)

    XCTAssertEqual(
      events.events,
      [
        .next(0, [event1]),
        .next(0, [event1, event2])
      ])
  }

  func testFavoriteItem() {
    let sut = EventsListUseCaseInteractor(
      remoteRepository: remoteRepository,
      localRepository: cacheRepository)
    _ = cacheRepository.overrideCache(with: [event1, event2])
    var favoriteEvent2 = event2!
    favoriteEvent2.isFavorite = true

    let events = scheduler.createObserver([Eventful.Event].self)
    sut.events().drive(events).disposed(by: disposeBag)

    let favorite = scheduler.createObserver(Void.self)
    sut.favorite(event: event2).bind(to: favorite).disposed(by: disposeBag)

    switch favorite.events.first?.value {
    case .next(()): break
    default: XCTFail("Events not favorited")
    }

    sut.events().drive(events).disposed(by: disposeBag)
    XCTAssertEqual(
      events.events,
      [
        .next(0, [event1, event2]),
        .next(0, [event1, favoriteEvent2])
      ])
  }

  func testFavoriteItemTwice() {
    let sut = EventsListUseCaseInteractor(
      remoteRepository: remoteRepository,
      localRepository: cacheRepository)
    _ = cacheRepository.overrideCache(with: [event1, event2])
    var favoriteEvent2 = event2!
    favoriteEvent2.isFavorite = true

    let events = scheduler.createObserver([Eventful.Event].self)
    sut.events().drive(events).disposed(by: disposeBag)

    let favorite = scheduler.createObserver(Void.self)
    sut.favorite(event: event2).bind(to: favorite).disposed(by: disposeBag)
    sut.favorite(event: event2).bind(to: favorite).disposed(by: disposeBag)

    switch favorite.events[0].value {
    case .next(()): break
    default: XCTFail("Event not favorited")
    }
    switch favorite.events[2].value {
    case .next(()): break
    default: XCTFail("Event not favorited")
    }

    sut.events().drive(events).disposed(by: disposeBag)
    XCTAssertEqual(
      events.events,
      [
        .next(0, [event1, event2]),
        .next(0, [event1, favoriteEvent2]),
        .next(0, [event1, favoriteEvent2])
      ])
  }

  func testUnfavoriteItem() {
    let sut = EventsListUseCaseInteractor(
      remoteRepository: remoteRepository,
      localRepository: cacheRepository)
    _ = cacheRepository.overrideCache(with: [event1, event2])
    _ = cacheRepository.favorite(event: event2)
    var favoriteEvent2 = event2!
    favoriteEvent2.isFavorite = true

    let events = scheduler.createObserver([Eventful.Event].self)
    sut.events().drive(events).disposed(by: disposeBag)

    let favorite = scheduler.createObserver(Void.self)
    sut.unfavorite(event: event2).bind(to: favorite).disposed(by: disposeBag)


    favorite.events.forEach {
      switch $0.value {
      case .next(()): break
      case .completed: break
      default: XCTFail("Events not unfavorited")
      }
    }

    sut.events().drive(events).disposed(by: disposeBag)
    XCTAssertEqual(
      events.events,
      [
        .next(0, [event1, favoriteEvent2]),
        .next(0, [event1, event2])
      ])
  }

  func testSutDeinit() {
    var sut: EventsListUseCaseInteractor? = EventsListUseCaseInteractor(
      remoteRepository: remoteRepository,
      localRepository: cacheRepository)

    remoteRepository.events = [event1, event2]

    let loading = scheduler.createObserver(Void.self)
    let loadingObservable = sut?.loadEvents(with: false)
    sut = nil
    loadingObservable?.bind(to: loading).disposed(by: disposeBag)


    switch loading.events[0].value {
    case .completed: break
    default: XCTFail("Event should completed without events on sut deinit")
    }
  }

  func testSutDeinitOnRemoteRequest() {
    var sut: EventsListUseCaseInteractor? = EventsListUseCaseInteractor(
      remoteRepository: remoteRepository,
      localRepository: cacheRepository)

    let validationExpectation = expectation(description: "Fullfilled")
    remoteRepository.waitTime = 2

    let loadingObservable = sut?.loadEvents(with: false)
    loadingObservable?
      .subscribe(
        onNext: { _ in XCTFail("Event should completed without events on sut deinit") },
        onError: { _ in XCTFail("Event should completed without events on sut deinit") },
        onCompleted: {
          validationExpectation.fulfill()
        })
      .disposed(by: disposeBag)
    sut = nil

    wait(for: [validationExpectation], timeout: 4)
  }
}
