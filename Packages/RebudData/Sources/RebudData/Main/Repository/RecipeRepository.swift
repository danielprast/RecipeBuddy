//
//  RecipeRepository.swift
//  RebudData
//
//  Created by Daniel Prastiwa on 13/08/25.
//

import Foundation
import BZUtil
import BZConnectionChecker


public protocol RecipeRepository {

  func getRecipes(title: String) async throws -> [RecipeEntity]
}


public protocol FavoritedRecipeRepository: Sendable {

  var favoritedRecipes: [String : RecipeEntity] { get async }

  func getFavoritedRecipes() async -> [RecipeEntity]

  func addToFavorite(_ recipe: RecipeEntity) async throws -> Bool

  func removeFavorite(_ recipe: RecipeEntity) async throws -> Bool
}


// MARK: - •

public actor RecipeRepositoryImplementation {

  private let recipeLocalDataStore: RecipeLocalDataStore
  private let recipeRemoteDataSource: RecipeRemoteDataSource
  private let networkConnectionChecker: NetworkConnectionChecker

  public init(
    networkConnectionChecker: NetworkConnectionChecker,
    recipeRemoteDataSource: RecipeRemoteDataSource,
    recipeLocalDataStore: RecipeLocalDataStore
  ) {
    self.networkConnectionChecker = networkConnectionChecker
    self.recipeRemoteDataSource = recipeRemoteDataSource
    self.recipeLocalDataStore = recipeLocalDataStore
  }

  // MARK: - • Recipe Repository

  public var favoritedRecipes: [String : RecipeEntity] {
    get async {
      let recipes = await getFavoritedRecipes()

      guard !recipes.isEmpty else {
        return [:]
      }

      var favoritedRecipes: [String : RecipeEntity] = [:]
      for recipe in recipes {
        favoritedRecipes[recipe.id] = recipe
      }

      return favoritedRecipes
    }
  }

  public func getRecipes(title: String) async throws -> [RecipeEntity] {
    if await !networkConnectionChecker.isConnected {
      throw RebudError.connectionProblem
    }

    do {
      let responses = try await recipeRemoteDataSource.fetchRecipes(title: title)
      return responses.map { RecipeEntity.mapFromResponse($0) }
    } catch {
      throw error as? RebudError ?? RebudError.custom("Failed to get recipes")
    }
  }

  // MARK: - • Favorited Recipe Repository

  public func getFavoritedRecipes() async -> [RecipeEntity] {
    let recipes = await recipeLocalDataStore.readFavoritedRecipes()
    return recipes.map { RecipeEntity.mapFromResponse($0) }
  }

  public func addToFavorite(_ recipe: RecipeEntity) async throws -> Bool {
    do {
      let element = recipe.mapToRecipeElement()
      return try await recipeLocalDataStore.saveFavorite(element)
    } catch {
      throw (error as! RebudError)
    }
  }

  public func removeFavorite(_ recipe: RecipeEntity) async throws -> Bool {
    do {
      let element = recipe.mapToRecipeElement()
      return try await recipeLocalDataStore.removeFavorite(element)
    } catch {
      throw (error as! RebudError)
    }
  }

}


extension RecipeRepositoryImplementation: RecipeRepository,
                                          FavoritedRecipeRepository {}
