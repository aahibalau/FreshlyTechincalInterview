//
//  ErrorPresentable.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/4/20.
//

import UIKit
import RxSwift

protocol ErrorPresentable {
  var errorViewModelChanged: AnyObserver<ErrorViewModelProtocol?> { get }
}

extension ErrorPresentable where Self: UIViewController {
  var errorViewModelChanged: AnyObserver<ErrorViewModelProtocol?> {
    return AnyObserver(eventHandler: { [weak self] event in
      guard let self = self,
        let element = event.element,
        let errorViewModel = element else {
          return
      }
      let alert = UIAlertController(
        title: errorViewModel.title,
        message: errorViewModel.message,
        preferredStyle: .alert)
      alert.addAction(.init(title: "Ok", style: .cancel, handler: nil))
      self.present(alert, animated: true)
    })
  }
}
