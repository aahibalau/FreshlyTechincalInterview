//
//  EventsListCoordinator.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/2/20.
//

import RxRelay
import RxSwift

class EventsListCoordinator:
  BaseCoordinator,
  EventsListViewModelDelegate
{
  let tab: Tab

  init(tab: Tab, serviceLocator: ServiceLocator) {
    self.tab = tab
    super.init(serviceLocator: serviceLocator)
  }

  // MARK: - Coordinator

  override func start() -> UIViewController {
    let viewController = EventsListViewController()
    let tabBarItem = UITabBarItem(title: tab.title, image: tab.icon, tag: 0)
    tabBarItem.accessibilityIdentifier = tab.title
    viewController.tabBarItem = tabBarItem
    viewController.descriptorBlock = CellDescriptor.eventCell
    let viewModel = EventsListViewModel(
      useCase: serviceLocator.resolve(EventsListUseCase.self, argument: tab),
      hasPullToRefresh: tab == .events)
    viewModel.delegate = self
    viewController.viewModel = viewModel

    self.viewController = viewController
    self.viewModel = viewModel
    return viewController
  }

  // MARK: - EventsListViewModelDelegate

  func showWebPage(for event: Event) {
    guard let pageUrl = URL(string: event.url) else { return }
    UIApplication.shared.open(pageUrl, options: [:], completionHandler: nil)
  }
}
