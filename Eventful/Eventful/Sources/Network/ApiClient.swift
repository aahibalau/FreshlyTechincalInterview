//
//  ApiClient.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/3/20.
//

import RxSwift

protocol ApiClient {
  func sendRequest<RequestEndpoint: Endpoint>(
    to endpoint: RequestEndpoint
  ) -> Observable<RequestEndpoint.Response>
}
