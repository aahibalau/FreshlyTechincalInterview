//
//  ListViewController.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/2/20.
//

import UIKit
import RxSwift
import PureLayout

class ListViewController<ViewModel: AbstractListViewModel>:
  UIViewController,
  TableViewDataSourceDelegate
{
  typealias CellType = ViewModel.CellType
  var viewModel: ViewModel!
  var descriptorBlock: ((CellType) -> CellDescriptor)!
  let disposeBag = DisposeBag()

  typealias DataSource =
    TableViewDataSource<ListDataProvider<CellType>, ListViewController>

  var dataSource: DataSource? {
    didSet { dataSource?.tableView = tableView }
  }

  var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    bindViewModel()
  }

  func setupTableView() {
    tableView = UITableView(forAutoLayout: ())
    view.addSubview(tableView)
    tableView.autoPinEdgesToSuperviewEdges()
  }

  func bindViewModel() {
    viewModel.dataProvider
      .drive(onNext: { [weak self] in
        self?.updateDataSource(with: $0)
      })
      .disposed(by: disposeBag)
  }

  private func updateDataSource(with dataProvider: ListDataProvider<CellType>) {
    dataSource = DataSource(dataProvider: dataProvider, delegate: self)
  }

  // MARK: -  TableViewDataSourceDelegate
  
  func cellDescriptor(for object: CellType, at indexPath: IndexPath) -> CellDescriptor {
    descriptorBlock(object)
  }

  func didSelect(_ object: CellType, at indexPath: IndexPath) {

  }
}
