//
//  AppServiceLocator+Factory.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/4/20.
//

import Swinject

extension AppServiceLocator {
  func registerUseCases(with container: Container) {
    container.register(EventsListUseCase.self) { (resolver, tab: Tab) in
      switch tab {
      case .events:
        return EventsListUseCaseInteractor(
          remoteRepository: resolver.resolve(EndfulRepository.self)!,
          localRepository: resolver.resolve(EventCacheRepository.self)!)
      case .favorites:
        return FavoriteEventsListUseCaseInteractor(
          favoriteRepository: resolver.resolve(FavoriteEventRepository.self)!)
      }
    }
  }

  func registerRepositories(with container: Container) {
    container.register(EndfulRepository.self) { resolver in
      WebEndfulRepository(
        apiClient: resolver.resolve(ApiClient.self)!,
        endpointFactory: EndfulEndpointFactory())
    }
    container.register(EventCacheRepository.self) { _ in
      RealmEventCacheRepository()
    }
    container.register(FavoriteEventRepository.self) { _ in
      RealmFavoriteEventRepository()
    }
  }

  func registerApiClient(with container: Container) {
    container.register(ApiClient.self) { resolver in
      URLSessionApiClient(apiConfiguration: resolver.resolve(ApiConfiguration.self)!)
    }
    .inObjectScope(.container)
    container.register(ApiConfiguration.self) { _ in
      EventfulApiConfiguration()
    }
  }
}
