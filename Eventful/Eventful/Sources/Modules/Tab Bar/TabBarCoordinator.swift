//
//  TabBarCoordinator.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/1/20.
//

import UIKit

class TabBarCoordinator: NSObject, RootCoordinator {
  private let serviceLocator: ServiceLocator
  private var tabs: [TabItem] = []
  weak var activeCoordinator: Coordinator? {
    didSet {
      guard oldValue != nil, oldValue !== activeCoordinator else { return }
      activeCoordinator?.reload()
    }
  }

  init(serviceLocator: ServiceLocator) {
    self.serviceLocator = serviceLocator
  }

  // MARK: - RootCoordinator

  func start(with window: UIWindow) {
    window.rootViewController = createTabBar()
  }

  func reload() {
    activeCoordinator?.reload()
  }

  // MARK: - Private

  private func createTabBar() -> UITabBarController {
    let eventsTabCoordinator = EventsListCoordinator(tab: .events, serviceLocator: serviceLocator)
    let favoritesTabCoordinator = EventsListCoordinator(
      tab: .favorites,
      serviceLocator: serviceLocator)
    let controller = UITabBarController()
    controller.delegate = self

    tabs = [
      TabItem(coordinator: eventsTabCoordinator, viewController: eventsTabCoordinator.start()),
      TabItem(coordinator: favoritesTabCoordinator, viewController: favoritesTabCoordinator.start()),
    ]

    setActiveCoordinator(with: controller.selectedIndex)
    controller.viewControllers = tabs.map { $0.viewController }
    return controller
  }

  private func setActiveCoordinator(with index: Int) {
    guard index > -1 && index < tabs.count else {
      activeCoordinator = nil
      return
    }
    activeCoordinator = tabs[index].coordinator
  }
}

extension TabBarCoordinator: UITabBarControllerDelegate {
  func tabBarController(
    _ tabBarController: UITabBarController,
    didSelect viewController: UIViewController
  ) {
    setActiveCoordinator(with: tabBarController.selectedIndex)
  }
}
