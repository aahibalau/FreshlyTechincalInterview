//
//  Coordinator.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/1/20.
//

import UIKit

protocol Coordinator: class {
  func start() -> UIViewController
  func reload()
}
