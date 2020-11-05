//
//  EventfulUITests.swift
//  EventfulUITests
//
//  Created by Andrei Ahibalau on 11/1/20.
//

import XCTest
import OHHTTPStubs

class EventfulUITests: XCTestCase {

  override func setUpWithError() throws {
    continueAfterFailure = false
  }

  override func tearDownWithError() throws {
    HTTPStubs.removeAllStubs()
  }

  private func reset(app: XCUIApplication, with args: [String]) {
    app.launchArguments = args
  }

  func testTabBarItems() throws {
    let app = XCUIApplication()
    app.launch()

    let eventsTabItem = app.tabBars.buttons["Events"]
    XCTAssertTrue(eventsTabItem.exists)
    XCTAssertEqual(eventsTabItem.label, "Events")
    XCTAssertTrue(eventsTabItem.isSelected)

    let favoritesTabItem = app.tabBars.buttons["Favorites"]
    XCTAssertTrue(favoritesTabItem.exists)
    XCTAssertEqual(favoritesTabItem.label, "Favorites")
    XCTAssertFalse(favoritesTabItem.isSelected)

    favoritesTabItem.tap()
    XCTAssertTrue(favoritesTabItem.isSelected)
    XCTAssertFalse(eventsTabItem.isSelected)
  }

  func testFavoriteEvent() throws {
    let app = XCUIApplication()
    reset(app: app, with: ["ui-tests"])
    app.launch()
    let secondEventCell = app.tables
      .element(boundBy: 0)
      .cells
      .element(boundBy: 1)
    XCTAssertEqual(secondEventCell.staticTexts.element(boundBy: 0).label, "2")
    XCTAssertEqual(secondEventCell.staticTexts.element(boundBy: 1).label, "16 Nov 20 10:00")
    XCTAssertTrue(secondEventCell.buttons["favorite inactive icon"].waitForExistence(timeout: 1))
    secondEventCell.buttons.firstMatch.tap()
    XCTAssertTrue(secondEventCell.buttons["favorite active icon"].waitForExistence(timeout: 1))
    app.tabBars.buttons["Favorites"].tap()

    let favoriteEventCell = app.tables
      .element(boundBy: 0)
      .cells
      .element(boundBy: 0)
    XCTAssertTrue(favoriteEventCell.waitForExistence(timeout: 1))
    XCTAssertEqual(favoriteEventCell.staticTexts.element(boundBy: 0).label, "2")
    XCTAssertEqual(favoriteEventCell.staticTexts.element(boundBy: 1).label, "16 Nov 20 10:00")
  }

  func testUnfavoriteEventFromEventsList() {
    let app = XCUIApplication()
    reset(app: app, with: ["ui-tests"])
    app.launch()
    let secondEventCell = app.tables
      .element(boundBy: 0)
      .cells
      .element(boundBy: 1)
    XCTAssertTrue(secondEventCell.waitForExistence(timeout: 1))
    secondEventCell.buttons.firstMatch.tap()
    XCTAssertTrue(secondEventCell.buttons["favorite active icon"].waitForExistence(timeout: 1))
    app.tabBars.buttons["Favorites"].tap()
    let favoriteEventCell = app.tables
      .element(boundBy: 0)
      .cells
      .element(boundBy: 0)
    XCTAssertTrue(favoriteEventCell.waitForExistence(timeout: 1))
    XCTAssertEqual(favoriteEventCell.staticTexts.element(boundBy: 0).label, "2")
    XCTAssertEqual(favoriteEventCell.staticTexts.element(boundBy: 1).label, "16 Nov 20 10:00")

    app.tabBars.buttons["Events"].tap()
    secondEventCell.buttons.firstMatch.tap()
    XCTAssertTrue(secondEventCell.buttons["favorite inactive icon"].waitForExistence(timeout: 1))

    app.tabBars.buttons["Favorites"].tap()
    XCTAssertFalse(favoriteEventCell.waitForExistence(timeout: 1))
  }

  func testOpenWebPageFromCacheList() {
    let app = XCUIApplication()
    reset(app: app, with: ["ui-tests"])
    app.launch()
    let firstEventCell = app.tables
      .element(boundBy: 0)
      .cells
      .element(boundBy: 0)
    XCTAssertTrue(firstEventCell.waitForExistence(timeout: 1))
    firstEventCell.tap()
    let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
    XCTAssertTrue(safari.waitForExistence(timeout: 10))
  }

  func testOpenWebPageFromFavoriteList() {
    let app = XCUIApplication()
    reset(app: app, with: ["ui-tests"])
    app.launch()
    let firstEventCell = app.tables
      .element(boundBy: 0)
      .cells
      .element(boundBy: 0)
    XCTAssertTrue(firstEventCell.waitForExistence(timeout: 1))
    firstEventCell.buttons.element.tap()
    app.tabBars.buttons["Events"].tap()
    let favoriteEventCell = app.tables
      .element(boundBy: 0)
      .cells
      .element(boundBy: 0)
    XCTAssertTrue(favoriteEventCell.waitForExistence(timeout: 1))
    favoriteEventCell.tap()

    let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
    XCTAssertTrue(safari.waitForExistence(timeout: 10))
  }
}
