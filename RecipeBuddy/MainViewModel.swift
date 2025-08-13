//
//  Untitled.swift
//  RebudData
//
//  Created by Daniel Prastiwa on 13/08/25.
//

import Foundation
import Combine
import RebudData


@MainActor
class MainViewModel: ObservableObject {

  init() {
    clog("inited", "\(Self.self)")
  }

  var unitName: String { "\(Self.self)" }

}
