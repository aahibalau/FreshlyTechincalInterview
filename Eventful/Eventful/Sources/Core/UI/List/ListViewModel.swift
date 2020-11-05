//
//  ListViewModel.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/2/20.
//

import RxSwift
import RxCocoa

protocol AbstractListViewModel {
  associatedtype CellType
  var dataProvider: Driver<ListDataProvider<CellType>> { get }
}

class ListViewModel<CellType>: AbstractListViewModel {
  private let dataProviderRelay = BehaviorRelay<ListDataProvider<CellType>>(
    value: ListDataProvider(items: []))
  var dataProvider: Driver<ListDataProvider<CellType>> {
    dataProviderRelay.asDriver()
  }

  func updateDataProvider(with items: [CellType]) {
    let dataProvider = ListDataProvider(items: items)
    dataProviderRelay.accept(dataProvider)
  }
}
