//
//  LoadingStatePresentable.swift
//  Eventful
//
//  Created by Andrei Ahibalau on 11/4/20.
//

import UIKit
import MBProgressHUD
import RxSwift

protocol LoadingStatePresentable {
  var loadingStateChanged: AnyObserver<LoadingState> { get }
}

extension LoadingStatePresentable where Self: UIViewController {
  var loadingStateChanged: AnyObserver<LoadingState> {
    view.loadingStateChanged
  }
}

extension UIView: LoadingStatePresentable {
  var loadingStateChanged: AnyObserver<LoadingState> {
    return AnyObserver(eventHandler: { [weak self] event in
      guard let state = event.element else {
        return
      }
      self?.updateHud(with: state)
    })
  }

  private func updateHud(with state: LoadingState) {
    switch state {
    case .initial: return
    case .loading(let identifier):
      showHud(with: identifier)
    case .none(let identifier):
      dismissHud(with: identifier)
    case .reset:
      resetHud()
    }
  }

  func showHud(with identifier: String) {
    loadingStack.push(identifier)
    MBProgressHUD.showAdded(to: self, animated: true)
  }

  func dismissHud(with identifier: String) {
    if loadingStack.pop(identifier) == 0 {
      MBProgressHUD.hide(for: self, animated: true)
    }
  }

  func resetHud() {
    loadingStack.reset()
    MBProgressHUD.hide(for: self, animated: true)
  }

  private enum AssociatedKey {
    static var loadingStackKey = "loadingStackKey"
   }

  private var loadingStack: LoadingStack {
    get {
      guard let stack: LoadingStack = getAssociatedObject(
        object: self, associativeKey: &AssociatedKey.loadingStackKey) else {
          let newStack = LoadingStack()
          setAssociatedObject(
            object: self,
            value: newStack,
            associativeKey: &AssociatedKey.loadingStackKey,
            policy: objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
          return newStack
      }
      return stack
    }
    set {
      setAssociatedObject(
        object: self,
        value: newValue,
        associativeKey: &AssociatedKey.loadingStackKey,
        policy: objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}

private class LoadingStack {
  private var identifiers: Set<String> = []
  @discardableResult
  func push(_ identifier: String) -> Int {
    identifiers.insert(identifier)
    return identifiers.count
  }
  func pop(_ identifier: String) -> Int {
    identifiers.remove(identifier)
    return identifiers.count
  }
  func reset() {
    identifiers = []
  }
}

import ObjectiveC

func setAssociatedObject<T>(
  object: AnyObject,
  value: T,
  associativeKey: UnsafeRawPointer,
  policy: objc_AssociationPolicy
) {
  objc_setAssociatedObject(object, associativeKey, value as AnyObject, policy)
}

func getAssociatedObject<T>(object: AnyObject, associativeKey: UnsafeRawPointer) -> T? {
  guard let value = objc_getAssociatedObject(object, associativeKey) as? T else { return nil }
  return value
}

