//
//  RootCoordinator.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/1/20.
//

import UIKit

protocol RootCoordinator: class {
  func start(with window: UIWindow)
  func reload()
}
