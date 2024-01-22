//
//  Rx+ViewDidLoad.swift
//  BeerList-MVVM
//
//  Created by MacBook on 22.01.2024.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UIViewController {
  var viewDidLoad: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
    return ControlEvent(events: source)
  }
}
