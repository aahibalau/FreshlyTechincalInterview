//
//  ListDataProvider.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/2/20.
//

import UIKit

class ListDataProvider<T>: DataProvider {
  typealias Object = T

  var items: [T]

  init(items: [T]) {
    self.items = items
  }

  func object(at indexPath: IndexPath) -> Object {
    return items[indexPath.row]
  }

  func numberOfItems(in section: Int) -> Int {
    return items.count
  }

  var numberOfSections: Int {
    return 1
  }
}
