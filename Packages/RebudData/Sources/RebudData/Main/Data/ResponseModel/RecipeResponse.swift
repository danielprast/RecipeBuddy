//
//  RecipeResponse.swift
//  RebudData
//
//  Created by Daniel Prastiwa on 13/08/25.
//

import Foundation


public typealias RecipeResponse = [RecipeResponseElement]


public struct RecipeResponseElement: Codable, Sendable {

  public let id, title: String
  public let tags: [String]
  public let minutes: Int
  public let image: String
  public let ingredients: [Ingredient]
  public let steps: [String]

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
    self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
    self.tags = try container.decodeIfPresent([String].self, forKey: .tags) ?? []
    self.minutes = try container.decodeIfPresent(Int.self, forKey: .minutes) ?? 0
    self.image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
    self.ingredients = try container.decodeIfPresent([RecipeResponseElement.Ingredient].self, forKey: .ingredients) ?? []
    self.steps = try container.decodeIfPresent([String].self, forKey: .steps) ?? []
  }

  public init(
    id: String,
    title: String,
    tags: [String],
    minutes: Int,
    image: String,
    ingredients: [Ingredient],
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

  public static func makeEmpty() -> RecipeResponseElement {
    .init(
      id: "",
      title: "",
      tags: [],
      minutes: 0,
      image: "",
      ingredients: [],
      steps: []
    )
  }

  // MARK: - •

  public struct Ingredient: Codable, Sendable {

    public let name, quantity: String

    public init(name: String, quantity: String) {
      self.name = name
      self.quantity = quantity
    }

    public init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<RecipeResponseElement.Ingredient.CodingKeys> = try decoder.container(keyedBy: RecipeResponseElement.Ingredient.CodingKeys.self)
      self.name = try container.decodeIfPresent(String.self, forKey: RecipeResponseElement.Ingredient.CodingKeys.name) ?? ""
      self.quantity = try container.decodeIfPresent(String.self, forKey: RecipeResponseElement.Ingredient.CodingKeys.quantity) ?? ""
    }

    public static func makeEmpty() -> Ingredient {
      .init(name: "", quantity: "")
    }

  }
}

