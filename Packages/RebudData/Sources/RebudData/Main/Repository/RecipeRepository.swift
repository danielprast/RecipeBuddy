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


public actor RecipeRepositoryImplementation: RecipeRepository {

  private let recipeRemoteDataSource: RecipeRemoteDataSource
  private let networkConnectionChecker: NetworkConnectionChecker

  public init(
    networkConnectionChecker: NetworkConnectionChecker,
    recipeRemoteDataSource: RecipeRemoteDataSource
  ) {
    self.networkConnectionChecker = networkConnectionChecker
    self.recipeRemoteDataSource = recipeRemoteDataSource
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

}
