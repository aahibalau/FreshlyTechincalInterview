//
//  EndfulRepository.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/3/20.
//

import Foundation
import RxSwift

protocol EndfulRepository {
  func searchEvents() -> Observable<[Event]>
}

class WebEndfulRepository: WebRepository {

  let endpointFactory: EndfulEndpointFactory

  init(apiClient: ApiClient, endpointFactory: EndfulEndpointFactory) {
    self.endpointFactory = endpointFactory
    super.init(apiClient: apiClient)
  }
}

extension WebEndfulRepository: EndfulRepository {
  func searchEvents() -> Observable<[Event]> {
    apiClient.sendRequest(to: endpointFactory.searchEventsEnpoint())
      .map { $0.events.event }
  }
}
