//
//  ErrorViewModelProvider.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/4/20.
//

import RxCocoa

protocol ErrorViewModelProvider: class {
  var errorViewModel: PublishRelay<ErrorViewModelProtocol?> { get }
}
