//
//  Observable+Utilities.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/4/20.
//

import Foundation
import RxSwift

extension Observable {
  func withLoading(from loadingModel: LoadingViewModel?) -> Observable {
    let identifier = UUID().uuidString
    loadingModel?.isLoading.accept(.loading(identifier))
    return self.do(
      afterNext: { [weak loadingModel] _ in
        loadingModel?.isLoading.accept(.none(identifier))
      },
      afterError: { [weak loadingModel] _ in
        loadingModel?.isLoading.accept(.none(identifier))
      },
      onDispose: { [weak loadingModel] in
        loadingModel?.isLoading.accept(.none(identifier))
      })
  }
}
