//
//  EventsListViewController.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/2/20.
//

import RxCocoa
import RxSwift
import UIKit

class EventsListViewController:
  ListViewController<EventsListViewModel>,
  LoadingStatePresentable,
  ErrorPresentable
{

  private var refreshControl = UIRefreshControl()

  override func viewDidLoad() {
    super.viewDidLoad()
    bindViewModel()
    viewModel.reloadData()
  }

  override func bindViewModel() {
    super.bindViewModel()
    viewModel.isLoading.asDriver()
      .drive(loadingStateChanged)
      .disposed(by: disposeBag)
    viewModel.errorViewModel
      .observeOn(MainScheduler.asyncInstance)
      .bind(to: errorViewModelChanged)
      .disposed(by: disposeBag)
    if viewModel.hasPullToRefresh {
      addPullToRefresh()
    }
  }

  private func addPullToRefresh() {
    tableView.refreshControl = refreshControl
    refreshControl.rx.action = viewModel.pullToRefreshAction
  }

  // MARK: - TableViewDataSourceDelegate

  override func didSelect(_ object: CellType, at indexPath: IndexPath) {
    object.selectionBlock()
  }
}
