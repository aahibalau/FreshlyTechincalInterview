//
//  BaseCoordinator.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/2/20.
//

import UIKit

class BaseCoordinator: Coordinator {
  weak var viewController: UIViewController?
  weak var viewModel: ReloadableViewModel?

  let serviceLocator: ServiceLocator

  init(serviceLocator: ServiceLocator) {
    self.serviceLocator = serviceLocator
  }

  func start() -> UIViewController { fatalError("Not implemented") }
  func reload() {
    viewModel?.reloadData()
  }
}
