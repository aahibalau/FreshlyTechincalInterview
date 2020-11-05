//
//  CellReuseMethods.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/2/20.
//

import UIKit

extension String {
  var reuseId: String { self }
  var nib: UINib { UINib(nibName: self, bundle: nil) }
}

extension UIView {
  static var nib: UINib { return "\(self)".nib }
}

extension UITableViewCell {
  static var reuseId: String { "\(self)".reuseId }
}

extension UITableView {
  func registerCell(with nibName: String, for reuseId: String) {
    register(nibName.nib, forCellReuseIdentifier: reuseId)
  }

  func register(nibName: String, forHeaderFooterReuseIdentifier identifier: String) {
    self.register(nibName.nib, forHeaderFooterViewReuseIdentifier: identifier)
  }
}
