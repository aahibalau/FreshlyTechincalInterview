//
//  CellDescriptor.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/2/20.
//

import UIKit

class CellDescriptor {
  let cellClass: UITableViewCell.Type
  let reuseId: String
  let nibName: String?
  let estimatedHeight: CGFloat
  let height: CGFloat
  let configure: (UITableViewCell, UITableView) -> Void

  init<Cell: UITableViewCell>(
    nibName: String? = nil,
    reuseId: String? = nil,
    estimatedHeight: CGFloat = 44,
    height: CGFloat = UITableView.automaticDimension,
    configure: @escaping (Cell, UITableView) -> Void
  ) {
    cellClass = Cell.self
    self.estimatedHeight = estimatedHeight
    self.height = height
    if let reuseId = reuseId {
      self.reuseId = reuseId
    } else if let nibName = nibName {
      self.reuseId = nibName
    } else {
      self.reuseId = Cell.reuseId
    }
    self.nibName = nibName
    self.configure = { configure($0 as! Cell, $1) }
  }

  func register(for table: UITableView) {
    if let nibName = nibName {
      table.registerCell(with: nibName, for: reuseId)
    } else {
      table.register(cellClass, forCellReuseIdentifier: reuseId)
    }
  }

  func cell(for table: UITableView, at indexPath: IndexPath) -> UITableViewCell {
    let cell = table.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
    configure(cell, table)
    return cell
  }

  func cell(for table: UITableView) -> UITableViewCell {
    let cell = table.dequeueReusableCell(withIdentifier: reuseId)!
    configure(cell, table)
    return cell
  }
}
