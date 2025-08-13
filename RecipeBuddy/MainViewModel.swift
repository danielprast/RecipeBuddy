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
public class MainViewModel: ObservableObject {

  public init() {}

  public var unitName: String { "\(Self.self)" }

}
