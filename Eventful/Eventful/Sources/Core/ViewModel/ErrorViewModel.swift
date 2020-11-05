//
//  ErrorViewModel.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/4/20.
//

import Foundation

protocol ErrorViewModelProtocol {
  var title: String { get }
  var message: String { get }
}

struct ErrorViewModel: ErrorViewModelProtocol {
  let title: String
  let message: String
}

