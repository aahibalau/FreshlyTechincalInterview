//
//  DataProvider.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/2/20.
//

import UIKit

protocol DataProvider: class {
  associatedtype Object
  func object(at indexPath: IndexPath) -> Object
  func numberOfItems(in section: Int) -> Int
  var numberOfSections: Int { get }
}
