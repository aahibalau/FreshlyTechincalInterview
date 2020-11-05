//
//  CellDescriptors.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/4/20.
//

import UIKit

extension CellDescriptor {
  static func eventCell(with viewModel: EventCellViewModel) -> CellDescriptor {
    CellDescriptor(nibName: R.nib.eventCell.name) { (cell: EventCell, tableView) in
      cell.viewModel = viewModel
    }
  }
}
