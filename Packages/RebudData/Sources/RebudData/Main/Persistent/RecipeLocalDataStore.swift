//
//  RecipeLocalDataStore.swift
//  RebudData
//
//  Created by Daniel Prastiwa on 13/08/25.
//

import Foundation
import BZUtil


public protocol RecipeLocalDataStore: Sendable {

  func readFavoritedRecipes() async -> [RecipeResponseElement]

  func saveFavorite(_ recipe: RecipeResponseElement) async throws -> Bool

  func removeFavorite(_ recipe: RecipeResponseElement) async throws -> Bool

}


public final actor RecipeLocalDataStoreImpl: RecipeLocalDataStore {

  public init() {}

  private var favoritedRecipes: [String : RecipeResponseElement] = [:]

  fileprivate func saveFavoritedRecipesToDisk() async {
    UserDefaults.standard.set(
      favoritedRecipes,
      forKey: RecipeLocalData().favoritedDataKey
    )
  }

  public func readFavoritedRecipes() async -> [RecipeResponseElement] {
    guard
      let persistentData = UserDefaults.standard.dictionary(forKey: RecipeLocalData().favoritedDataKey),
      let favoritedData = persistentData as? [String : RecipeResponseElement]
    else {
      return []
    }
    favoritedRecipes = favoritedData
    return favoritedRecipes.map { $0.value }
  }
  
  public func saveFavorite(_ recipe: RecipeResponseElement) async throws -> Bool {
    favoritedRecipes[recipe.id] = recipe
    await saveFavoritedRecipesToDisk()
    return true
  }
  
  public func removeFavorite(_ recipe: RecipeResponseElement) async throws -> Bool {
    guard let deleted = favoritedRecipes.removeValue(forKey: recipe.id) else {
      throw RebudError.custom("Failed to remove favorite for: \(recipe.title)")
    }
    await saveFavoritedRecipesToDisk()
    return favoritedRecipes[recipe.id] == nil
  }

}


public typealias RecipeLocalData = String


private extension RecipeLocalData {

  var dataKey: String {
    "recipe_local_datakey"
  }

  var favoritedDataKey: String {
    "recipe_local_fav_datakey"
  }

}
