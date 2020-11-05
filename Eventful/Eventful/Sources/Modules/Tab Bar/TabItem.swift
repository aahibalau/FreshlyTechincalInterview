//
//  TabItem.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/1/20.
//

import UIKit

enum Tab {
  case events, favorites

  var title: String {
    switch self {
    case .events: return "Events"
    case .favorites: return "Favorites"
    }
  }
  var icon: UIImage? {
    switch self {
    case .events: return R.image.events_icon()
    case .favorites: return R.image.favorites_icon()
    }
  }
}

struct TabItem {
  let coordinator: Coordinator
  let viewController: UIViewController
}
