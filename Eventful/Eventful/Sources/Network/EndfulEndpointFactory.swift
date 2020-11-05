//
//  EndfulEndpointFactory.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/3/20.
//

import Foundation

class EndfulEndpointFactory {
  private func baseRequestParameters() -> BaseRequestParameters {
    BaseRequestParameters(appKey: "CKKnt488bNT6HK2c")
  }

  func searchEventsEnpoint() -> BaseEndopoint<SearchEventsRequest, EventfulApiResponse> {
    BaseEndopoint(
      configuration: EventfulApi.searchEvents,
      parameters: SearchEventsRequest(
        baseParameters: baseRequestParameters(),
        keywords: "books",
        location: "San Diego",
        date: .future),
      encoder: EncoderFactory.urlEncodeFunction(),
      decoder: DecoderFactory.apiJsonDecodeFunction(with: .server()))
  }
}
