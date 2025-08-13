//
//  RecipeTagEntity.swift
//  RebudData
//
//  Created by Daniel Prastiwa on 13/08/25.
//

import Foundation


public struct RecipeTagEntity: Sendable, Identifiable, Equatable {

  public let id: String
  public let tag: String

  public init(
    id: String = UUID().uuidString,
    tag: String
  ) {
    self.id = id
    self.tag = tag
  }

  public static func == (lhs: RecipeTagEntity, rhs: RecipeTagEntity) -> Bool {
    lhs.tag == rhs.tag
  }

}
