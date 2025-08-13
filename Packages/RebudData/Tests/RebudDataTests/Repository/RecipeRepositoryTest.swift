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
      recipeRemoteDataSource: RecipeJsonDataSource(),
      recipeLocalDataStore: RecipeLocalDataStoreImpl()
    )
  }

  func test_GetRecipesJsonWithConnectedNetworkStateReturnRecipesData() async {
    let sut = makeSUT(isNetworkAvailable: true)
    do {
      let result = try await sut.getRecipes(title: "")
      XCTAssertTrue(!result.isEmpty)
    } catch {
      print("Failed to get recipes")
    }
  }

  func test_GetRecipesJsonWithDisconnectedNetworkState_Throw_RebudErrorConnectionProblem() async {
    let sut = makeSUT(isNetworkAvailable: false)
    do {
      _ = try await sut.getRecipes(title: "")
    } catch {
      XCTAssertTrue(error is RebudError)
      XCTAssertTrue((error as! RebudError) == .connectionProblem)
    }
  }

  func test_GetAllRecipesWithEmptyValueTitleArgument_ReturnsFilteredRecipeEntity() async {
    let sut = makeSUT(isNetworkAvailable: true)
    do {
      let recipes = try await sut.getRecipes(title: "")
      XCTAssertTrue(!recipes.isEmpty)
      XCTAssertEqual(recipes.count, 3)
    } catch {
      clog("error occured", error)
    }
  }

  func test_GetRecipesWithTitleArgumentValueOvernight_ReturnsFilteredRecipeEntity() async {
    let sut = makeSUT(isNetworkAvailable: true)
    do {
      let filteredRecipes = try await sut.getRecipes(title: "Overnight")
      XCTAssertEqual(filteredRecipes.first!.id, "r3")
    } catch {
      clog("error occured", error)
    }
  }

}
