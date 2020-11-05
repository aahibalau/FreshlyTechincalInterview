//
//  EventsListViewModel.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/2/20.
//

import Action
import RxCocoa
import RxSwift

protocol EventsListViewModelProtocol:
  AbstractListViewModel,
  ReloadableViewModel,
  LoadingViewModel,
  ErrorViewModelProvider
{
  var hasPullToRefresh: Bool { get }
  var pullToRefreshAction: CocoaAction { get }
}

class EventsListViewModel:
  ListViewModel<EventCellViewModel>,
  ReloadableViewModel,
  LoadingViewModel
{

  weak var delegate: EventsListViewModelDelegate?
  let hasPullToRefresh: Bool
  private let useCase: EventsListUseCase
  private var disposeBag = DisposeBag()

  // MARK: - Initializators

  init(useCase: EventsListUseCase, hasPullToRefresh: Bool) {
    self.useCase = useCase
    self.hasPullToRefresh = hasPullToRefresh
  }

  // MARK: - Public

  func reloadData() {
    disposeBag = DisposeBag()
    useCase.loadEvents(with: false)
      .withLoading(from: self)
      .subscribe(
        onNext: { [weak self] in
          self?.bindEvents()
        },
        onError: { [weak self] error in
          self?.errorViewModel.accept(
            ErrorViewModel(title: "error", message: error.localizedDescription))
        })
      .disposed(by: disposeBag)
  }

  let isLoading = BehaviorRelay<LoadingState>(value: .initial)
  let errorViewModel = PublishRelay<ErrorViewModelProtocol?>()

  lazy var pullToRefreshAction = CocoaAction { [weak self] in
    self?.useCase.loadEvents(with: true) ?? .empty()
  }

  // MARK: - Private

  private func bindEvents() {
    useCase.events()
      .map {
        $0.map { event -> EventCellViewModel in
          EventCellViewModel(
            event: event,
            selectionBlock: { [weak self] in
              self?.delegate?.showWebPage(for: event)
            },
            favoriteAction: Action<Bool, Void> { [weak self] in
              ($0 ?
                self?.useCase.unfavorite(event: event) :
                self?.useCase.favorite(event: event)) ?? .empty()
            })
        }
      }
      .drive(onNext:{ [weak self] in self?.updateDataProvider(with: $0) })
      .disposed(by: disposeBag)
  }
}
