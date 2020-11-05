//
//  URLSessionApiClient.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/3/20.
//

import RxSwift
import RxCocoa

class URLSessionApiClient: NSObject, ApiClient {
  private let apiConfiguration: ApiConfiguration
  private lazy var urlSession = URLSession(configuration: .default)

  init(apiConfiguration: ApiConfiguration) {
    self.apiConfiguration = apiConfiguration
  }

  // MARK: - Send Request

  func sendRequest<RequestEndpoint>(
    to endpoint: RequestEndpoint
  ) -> Observable<RequestEndpoint.Response> where RequestEndpoint : Endpoint {
    createRequest(for: endpoint)
      .flatMapLatest { [weak self] in
        self?.urlSession.rx.response(request: $0) ?? .empty()
      }
      .do(onNext: { (response: HTTPURLResponse, data: Data) in
        print("Api Endpoint: \(endpoint.configuration.path)",
          "response \(response.url?.absoluteString ?? "(nil)")",
          "body\n\(String(data: data, encoding: .utf8) ?? "(nil)")",
          separator: "\n")
      })
      .map { try endpoint.decode(data: $0.data) }
      .observeOn(MainScheduler.asyncInstance)
  }

  // MARK: - Private

  private func createRequest<RequestEndpoint: Endpoint>(
    for endpoint: RequestEndpoint
  ) -> Observable<URLRequest> {
    do {
      var request = URLRequest(url: baseUrl)
      request.httpMethod = endpoint.configuration.method.rawValue
      try endpoint.encode(reqeust: &request)

      return .just(request)
    } catch {
      return .error(error)
    }
  }

  // MARK: - URL

  private var baseUrl: URL {
    URL(string: apiConfiguration.baseUrlString)!
  }
}
