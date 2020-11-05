//
//  BaseEndpointTests.swift
//  EventfulTests
//
//  Created by Andrei Ahibalau on 11/5/20.
//

import XCTest
@testable import Eventful

class BaseEndpointTests: XCTestCase {

  var baseUrl: URL!
  var event: Eventful.Event!

  override func setUpWithError() throws {
    baseUrl = URL(string: EventfulApiConfiguration().baseUrlString)!
    event = Eventful.Event(
      identifier: "1",
      title: "1",
      url: "url",
      startDate: Date(timeIntervalSinceReferenceDate: 627202800))
  }

  func testEncode() throws {
    var request = URLRequest(url: baseUrl)
    let sut = EndfulEndpointFactory().searchEventsEnpoint()
    try sut.encode(reqeust: &request)
    guard let finalUrl = request.url,
          let components = URLComponents(url: finalUrl, resolvingAgainstBaseURL: true),
          let queryItems = components.queryItems else {
      XCTFail("Final url was not built")
      return
    }
    var parameters = [String: String]()
    for queryItem in queryItems {
      parameters[queryItem.name] = queryItem.value
    }

    XCTAssert(components.path == sut.configuration.path)
    XCTAssert(queryItems.count == 4)
    XCTAssert(parameters["app_key"] == "CKKnt488bNT6HK2c")
    XCTAssert(parameters["keywords"] == "books")
    XCTAssert(parameters["location"] == "San Diego")
    XCTAssert(parameters["date"] == "Future")
  }

  func testInvalidUrl() {
    do {
      var emptyRequest = URLRequest(url: baseUrl)
      emptyRequest.url = nil
      let sut = EndfulEndpointFactory().searchEventsEnpoint()
      try sut.encode(reqeust: &emptyRequest)
      XCTFail("Test should throw error")
    } catch {
      guard let encodeError = error as? EncodeError else {
        XCTFail("wrong catch error")
        return
      }
      XCTAssert(encodeError == .emptyUrl, "wrong catch error")
    }
  }

  func testDecode() throws {
    let testBundle = Bundle(for: type(of: self))
    guard let mockDataUrl = testBundle.url(forResource: "mockResponse", withExtension: ".json") else {
      XCTFail("mock data not found")
      return
    }
    let mockData = try Data(contentsOf: mockDataUrl)
    let sut = EndfulEndpointFactory().searchEventsEnpoint()
    let response = try sut.decode(data: mockData)

    XCTAssert(response.events.event.count == 1)
    XCTAssert(response.events.event.first == event)
  }

  func testInvalidData() {
    do {
      let responseJSON = "{}"
      let stubData = responseJSON.data(using: String.Encoding.utf8)!
      let sut = EndfulEndpointFactory().searchEventsEnpoint()
      _ = try sut.decode(data: stubData)
      XCTFail("Error should be produced")
    } catch {}
  }
}
