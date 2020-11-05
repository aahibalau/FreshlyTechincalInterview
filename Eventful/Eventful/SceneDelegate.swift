//
//  SceneDelegate.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/1/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  private let serviceLocator: ServiceLocator = AppServiceLocator.shared
  private var rootCoordinator: RootCoordinator?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let rootCoordinator = TabBarCoordinator(serviceLocator: serviceLocator)
    self.rootCoordinator = rootCoordinator
    let window = UIWindow(windowScene: windowScene)
    rootCoordinator.start(with: window)
    window.makeKeyAndVisible()
    self.window = window
  }
}

