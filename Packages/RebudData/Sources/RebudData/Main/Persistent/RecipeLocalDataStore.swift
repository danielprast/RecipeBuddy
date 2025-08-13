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

  fileprivate func saveFavoritedRecipesToDisk() async throws {
    let recipes = favoritedRecipes.map { $0.value }
    let key = RecipeLocalData().favoritedDataKey
    do {
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted
      let jsonData = try encoder.encode(recipes)
      UserDefaults.standard.set(jsonData,forKey: key)
    } catch {
      throw RebudError.custom("Failed to save favorited recipes")
    }
  }

  public func readFavoritedRecipes() async -> [RecipeResponseElement] {
    let key = RecipeLocalData().favoritedDataKey
    guard
      let persistentData = UserDefaults.standard.data(forKey: key),
      let recipes = JsonResolver.decodeJson(
        from: persistentData,
        outputType: [RecipeResponseElement].self
      )
    else {
      return []
    }

    favoritedRecipes.removeAll()
    for recipe in recipes {
      favoritedRecipes[recipe.id] = recipe
    }

    return recipes
  }
  
  public func saveFavorite(_ recipe: RecipeResponseElement) async throws -> Bool {
    favoritedRecipes[recipe.id] = recipe
    guard let _ = try? await saveFavoritedRecipesToDisk() else {
      return false
    }
    return true
  }
  
  public func removeFavorite(_ recipe: RecipeResponseElement) async throws -> Bool {
    guard let _ = favoritedRecipes.removeValue(forKey: recipe.id) else {
      throw RebudError.custom("Failed to remove favorite for: \(recipe.title)")
    }

    guard let _ = try? await saveFavoritedRecipesToDisk() else {
      return false
    }

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
