//
//  AppServiceLocator.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/2/20.
//

import Swinject

class AppServiceLocator {

  static let shared = configuredServiceLocator()

  let container: Container

  private class func configuredServiceLocator() -> AppServiceLocator {
    let serviceLocator = AppServiceLocator(container: Container())
    return serviceLocator
  }

  init(container: Container) {
    self.container = container

    registerApiClient(with: container)
    registerRepositories(with: container)
    registerUseCases(with: container)
  }
}

extension AppServiceLocator: ServiceLocator {
  func resolve<Service>(_ serviceType: Service.Type) -> Service {
    guard let service = container.resolve(serviceType) else {
      fatalError("Please, register all your services, especially \(serviceType)")
    }
    return service
  }

  func resolve<Service, Arg>(_ serviceType: Service.Type, argument: Arg) -> Service {
    guard let service = container.resolve(serviceType, argument: argument) else {
      fatalError("Please, register all your services, especially \(serviceType)")
    }
    return service
  }
}
