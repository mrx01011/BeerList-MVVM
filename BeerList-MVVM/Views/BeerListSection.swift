//
//  BeerListSection.swift
//  BeerList-MVVM
//
//  Created by MacBook on 22.01.2024.
//

import Foundation
import RxDataSources

struct BeerListSection {
  let header: String
  var items: [Beer]
}

extension BeerListSection: SectionModelType {
  init(original: BeerListSection, items: [Beer]) {
    self = original
    self.items = items
  }
}
