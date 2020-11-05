//
//  SearchEventsRequest.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/3/20.
//

struct SearchEventsRequest: URLEncodable {
  enum EventDate: String {
    case future = "Future"
  }

  let baseParameters: BaseRequestParameters
  let keywords: String
  let location: String
  let date: EventDate

  func queryParameters() -> [String: String] {
    var parameters = baseParameters.queryParameters()
    parameters["keywords"] = keywords
    parameters["location"] = location
    parameters["date"] = date.rawValue
    return parameters
  }
}
