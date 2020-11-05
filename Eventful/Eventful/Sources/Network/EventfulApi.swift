//
//  EventfulApi.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/3/20.
//

enum EventfulApi {
  case searchEvents
}

extension EventfulApi: EndpointConfiguration {
  var path: String {
    switch self {
    case .searchEvents: return "/json/events/search"
    }
  }
  
  var method: Method { .get }
}
