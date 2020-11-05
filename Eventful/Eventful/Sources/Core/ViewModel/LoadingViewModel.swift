//
//  LoadingViewModel.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/4/20.
//

import RxCocoa

enum LoadingState {
  case initial
  case loading(String)
  case none(String)
  case reset
}

protocol LoadingViewModel: class {
  var isLoading: BehaviorRelay<LoadingState> { get }
}
