//
//  TableViewDataSourceDelegate.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/2/20.
//

import UIKit

protocol TableViewDataSourceDelegate: class {
  associatedtype Object
  func cellDescriptor(for object: Object, at indexPath: IndexPath) -> CellDescriptor

  func didSelect(_ object: Object, at indexPath: IndexPath)
}
