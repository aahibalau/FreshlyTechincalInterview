//
//  URLSessionApiClientTests.swift
//  EventfulTests
//
//  Created by Andrei Ahibalau on 11/5/20.
//

import XCTest
import RxSwift
import OHHTTPStubs
import RxTest
@testable import Eventful

class URLSessionApiClientTests: XCTestCase {

  var configuration: EventfulApiConfiguration!
  var disposeBag: DisposeBag!
  var scheduler: TestScheduler!

  var event: Eventful.Event!

  override func setUpWithError() throws {
    configuration = EventfulApiConfiguration()
    disposeBag = DisposeBag()
    scheduler = TestScheduler(initialClock: 0)
    event = Eventful.Event(
      identifier: "1",
      title: "1",
      url: "url",
      startDate: Date(timeIntervalSinceReferenceDate: 627202800))
  }

  func testSendRequestSuccess() throws {
    let sut = URLSessionApiClient(apiConfiguration: configuration)
    let validationExpectation = self.expectation(description: "Fullfilled")
    let event = self.event!
    stub(condition: isMethodGET()) { request -> HTTPStubsResponse in
      HTTPStubsResponse(
        fileAtPath: OHPathForFile("mockResponse.json", type(of: self))!,
        statusCode: 200,
        headers: nil)
    }

    sut.sendRequest(to: EndfulEndpointFactory().searchEventsEnpoint())
      .subscribe { response in
        XCTAssert(response.events.event.count == 1)
        XCTAssert(response.events.event.first == event)
      } onError: { error in
        XCTFail(error.localizedDescription)
      } onCompleted: {
        validationExpectation.fulfill()
      }
      .disposed(by: disposeBag)

    waitForExpectations(timeout: 4) { error in
      HTTPStubs.removeAllStubs()
    }
  }

  func testSendRequestFailed() throws {
    let sut = URLSessionApiClient(apiConfiguration: configuration)
    let validationExpectation = self.expectation(description: "Fullfilled")
    stub(condition: isMethodGET()) { request -> HTTPStubsResponse in
      let responseJSON = "{}"
      let stubData = responseJSON.data(using: String.Encoding.utf8)
      return HTTPStubsResponse(data:stubData!, statusCode:200, headers:nil)
    }

    sut.sendRequest(to: EndfulEndpointFactory().searchEventsEnpoint())
      .subscribe { response in
        XCTFail()
      } onError: { error in
        validationExpectation.fulfill()
      } onCompleted: {
        XCTFail()
      }
      .disposed(by: disposeBag)

    waitForExpectations(timeout: 4) { error in
      HTTPStubs.removeAllStubs()
    }
  }
}
