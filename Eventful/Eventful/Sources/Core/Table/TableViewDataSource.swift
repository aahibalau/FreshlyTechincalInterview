//
//  TableViewDataSource.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/2/20.
//

import UIKit

class TableViewDataSource<Data: DataProvider, Delegate: TableViewDataSourceDelegate>:
  NSObject,
  UITableViewDataSource,
  UITableViewDelegate
where Data.Object == Delegate.Object {
//swiftlint:enable colon
  unowned var delegate: Delegate
  weak var tableView: UITableView? {
    didSet {
      tableView?.delegate = self
      tableView?.dataSource = self
      tableView?.reloadData()
    }
  }
  let dataProvider: Data
  private weak var scrollViewDelegate: UIScrollViewDelegate?
  private var registeredIdentifiers: Set<String> = []

  var selectedObject: Data.Object? {
    guard let selectedIndexPath = tableView?.indexPathForSelectedRow else {
      return nil
    }
    return dataProvider.object(at: selectedIndexPath)
  }

  init(dataProvider: Data, delegate: Delegate) {
    self.dataProvider = dataProvider
    self.delegate = delegate
    super.init()
  }

  // MARK: - UITableViewDataSource

  func numberOfSections(in tableView: UITableView) -> Int {
    return dataProvider.numberOfSections
  }

  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return dataProvider.numberOfItems(in: section)
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let object = dataProvider.object(at: indexPath)
    let descriptor = delegate.cellDescriptor(for: object, at: indexPath)

    if !registeredIdentifiers.contains(descriptor.reuseId) {
      descriptor.register(for: tableView)
      registeredIdentifiers.insert(descriptor.reuseId)
    }
    return descriptor.cell(for: tableView, at: indexPath)
  }

  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    tableView.deselectRow(at: indexPath, animated: true)
    let object = dataProvider.object(at: indexPath)
    delegate.didSelect(object, at: indexPath)
  }

  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    let object = dataProvider.object(at: indexPath)
    let descriptor = delegate.cellDescriptor(for: object, at: indexPath)
    return descriptor.height
  }

  // MARK: - ScrollViewDelegate

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    scrollViewDelegate?.scrollViewDidScroll?(scrollView)
  }

  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    scrollViewDelegate?.scrollViewDidZoom?(scrollView)
  }

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    scrollViewDelegate?.scrollViewWillBeginDragging?(scrollView)
  }

  func scrollViewWillEndDragging(
    _ scrollView: UIScrollView,
    withVelocity velocity: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>
  ) {
    scrollViewDelegate?.scrollViewWillEndDragging?(
      scrollView,
      withVelocity: velocity,
      targetContentOffset: targetContentOffset)
  }

  func scrollViewDidEndDragging(
    _ scrollView: UIScrollView,
    willDecelerate decelerate: Bool
  ) {
    scrollViewDelegate?.scrollViewDidEndDragging?(
      scrollView,
      willDecelerate: decelerate)
  }
}
