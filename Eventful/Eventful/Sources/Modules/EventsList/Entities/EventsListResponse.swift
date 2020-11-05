//
//  EventsListResponse.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/3/20.
//

import Foundation

struct EventfulApiResponse: Decodable {
  let events: EventsListResponse
}

struct EventsListResponse: Decodable {
  let event: [Event]
}
