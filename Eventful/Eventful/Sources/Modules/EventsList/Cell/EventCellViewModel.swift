//
//  EventCellViewModel.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/2/20.
//

import Foundation
import Action

class EventCellViewModel {
  let title: String
  let dateTimeString: String
  let favoriteImage: UIImage?

  let selectionBlock: () -> Void
  let favoriteAction: CocoaAction

  init(event: Event, selectionBlock: @escaping () -> Void, favoriteAction: Action<Bool, Void>) {
    self.favoriteAction = CocoaAction {
      favoriteAction.execute(event.isFavorite)
    }
    self.selectionBlock = selectionBlock
    self.title = event.title
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMM yy hh:mm"
    self.dateTimeString = formatter.string(from: event.startDate)
    favoriteImage = event.isFavorite ?
      R.image.favorite_active_icon() :
      R.image.favorite_inactive_icon()
  }
}
