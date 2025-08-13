//
//  RecipeIngredientEntity.swift
//  RebudData
//
//  Created by Daniel Prastiwa on 13/08/25.
//

import Foundation


public struct RecipeIngredientEntity: Sendable, Identifiable, Equatable {

  public let id: String
  public let name, quantity: String

  public init(
    id: String = UUID().uuidString,
    name: String,
    quantity: String
  ) {
    self.id = id
    self.name = name
    self.quantity = quantity
  }

  public static func == (lhs: RecipeIngredientEntity, rhs: RecipeIngredientEntity) -> Bool {
    lhs.name == rhs.name &&
    lhs.quantity == rhs.quantity
  }

}
