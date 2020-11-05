//
//  AppDelegate.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/1/20.
//

import UIKit
import OHHTTPStubs

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    applyUITestsSettingsIfNeeded()
    return true
  }

  private func applyUITestsSettingsIfNeeded() {
    let infoArguments = ProcessInfo.processInfo.arguments
    if infoArguments.contains("ui-tests") {
      stub(condition: isMethodGET()) { request -> HTTPStubsResponse in
        HTTPStubsResponse(
          fileAtPath: OHPathForFile("mockResponse.json", type(of: self))!,
          statusCode: 200,
          headers: nil)
      }
      let documentUrl = try! FileManager.default.url(
        for: .documentDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: true
      )
      let cachedUrl = documentUrl.appendingPathComponent("CachedEventsData.realm")
      eraseRealmDBs(for: cachedUrl)
      let favoriteUrl = documentUrl.appendingPathComponent("FavoriteEventsData.realm")
      eraseRealmDBs(for: favoriteUrl)
    }
  }

  private func eraseRealmDBs(for pathUrl: URL) {
    if FileManager.default.fileExists(atPath: pathUrl.path) {
      try? FileManager.default.removeItem(at: pathUrl)
    }
  }
}

