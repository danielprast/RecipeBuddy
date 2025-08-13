//
//  RecipeRepositoryTest.swift
//  RebudData
//
//  Created by Daniel Prastiwa on 13/08/25.
//

import XCTest
@testable import RebudData


final class RecipeRepositoryTest: XCTestCase {

  var sut: RecipeRepository!

  func makeSUT(isNetworkAvailable: Bool) -> RecipeRepository {
    RecipeRepositoryImplementation(
      networkConnectionChecker: MockNetworkConnectionChecker(isConnected: isNetworkAvailable),
      recipeRemoteDataSource: RecipeJsonDataSource()
    )
  }

  func test_GetRecipesJsonWithConnectedNetworkStateReturnRecipesData() async {
    let sut = makeSUT(isNetworkAvailable: true)
    do {
      let result = try await sut.getRecipes()
      XCTAssertTrue(!result.isEmpty)
    } catch {
      print("Failed to get recipes")
    }
  }

  func test_GetRecipesJsonWithDisconnectedNetworkState_Throw_RebudErrorConnectionProblem() async {
    let sut = makeSUT(isNetworkAvailable: false)
    do {
      _ = try await sut.getRecipes()
    } catch {
      XCTAssertTrue(error is RebudError)
      XCTAssertTrue((error as! RebudError) == .connectionProblem)
    }
  }

}
