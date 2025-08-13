//
//  MockNetworkConnectionChecker.swift
//  RebudData
//
//  Created by Daniel Prastiwa on 13/08/25.
//

import Foundation
import BZConnectionChecker


public actor MockNetworkConnectionChecker: NetworkConnectionChecker {

  private var _isConnected: Bool

  public init(isConnected: Bool) {
    self._isConnected = isConnected
  }

  public var isConnected: Bool {
    get async {
      true
    }
  }
}
