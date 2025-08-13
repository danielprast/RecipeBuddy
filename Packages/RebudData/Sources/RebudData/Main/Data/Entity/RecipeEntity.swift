//
//  RecipeEntity.swift
//  RebudData
//
//  Created by Daniel Prastiwa on 13/08/25.
//

import Foundation


public struct RecipeEntity: Sendable, Identifiable, Equatable {

  public let id: String
  public let title: String
  public let tags: [RecipeTagEntity]
  public let minutes: Int
  public let image: String
  public let ingredients: [RecipeIngredientEntity]
  public let steps: [String]

  public init(
    id: String,
    title: String,
    tags: [RecipeTagEntity],
    minutes: Int,
    image: String,
    ingredients: [RecipeIngredientEntity],
    steps: [String]
  ) {
    self.id = id
    self.title = title
    self.tags = tags
    self.minutes = minutes
    self.image = image
    self.ingredients = ingredients
    self.steps = steps
  }

  public static func mapFromResponse(_ response: RecipeResponseElement) -> RecipeEntity {
    _mapFromResponse(response)
  }

  public static func == (lhs: RecipeEntity, rhs: RecipeEntity) -> Bool {
    lhs.id == rhs.id
  }

}


fileprivate func _mapFromResponse(_ response: RecipeResponseElement) -> RecipeEntity {
  .init(
    id: response.id,
    title: response.title,
    tags: response.tags.map { RecipeTagEntity(tag: $0)
    },
    minutes: response.minutes,
    image: response.image,
    ingredients: response.ingredients.map {
      RecipeIngredientEntity(
        name: $0.name,
        quantity: $0.quantity
      )
    },
    steps: response.steps
  )
}
