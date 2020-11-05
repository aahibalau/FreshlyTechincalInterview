//
//  EventCell.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/4/20.
//

import UIKit

class EventCell: UITableViewCell {
  var viewModel: EventCellViewModel? {
    didSet { configureWithViewModel() }
  }

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var dateTimeLabel: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!

  override func prepareForReuse() {
    super.prepareForReuse()
    viewModel = nil
  }


  private func configureWithViewModel() {
    nameLabel.text = viewModel?.title
    dateTimeLabel.text = viewModel?.dateTimeString
    favoriteButton.setImage(viewModel?.favoriteImage, for: .normal)
    favoriteButton.rx.action = viewModel?.favoriteAction
  }
}
