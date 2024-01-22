//
//  ArrangeSubviews.swift
//  BeerList-MVVM
//
//  Created by MacBook on 22.01.2024.
//

import UIKit

extension UIStackView {
    func addArrangeSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
