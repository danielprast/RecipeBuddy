//
//  RecipeRemoteDataSource.swift
//  RebudData
//
//  Created by Daniel Prastiwa on 13/08/25.
//

import Foundation
import BZUtil


public protocol RecipeRemoteDataSource: Sendable {

  func fetchRecipes(title: String) async throws -> [RecipeResponseElement]
}


public struct RecipeJsonDataSource : RecipeRemoteDataSource {

  public init() {}

  public func fetchRecipes(title: String) async throws -> [RecipeResponseElement] {
    guard
      let jsonData = JsonResolver.readJsonFileFromResource(
        bundle: .module,
        fileName: "recipes"
      ),
      let dataModels = JsonResolver.decodeJson(
        from: jsonData,
        outputType: [RecipeResponseElement].self
      )
    else {
      throw RebudError.custom("Failed to read recipe.json")
    }

    if !title.isEmpty {
      return dataModels.filter { $0.title.contains(title) }
    }

    return dataModels
  }

}
