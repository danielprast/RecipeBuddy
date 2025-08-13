//
//  RecipeViewModelTest.swift
//  RecipeBuddy
//
//  Created by Daniel Prastiwa on 13/08/25.
//

import XCTest
import RebudData
@testable import RecipeBuddy


final class RecipeViewModelTest: XCTestCase {

  func makeSUT() async -> RecipeViewModel {
    let repository = RecipeRepositoryImplementation(
      networkConnectionChecker: MockNetworkConnectionChecker(isConnected: true),
      recipeRemoteDataSource: RecipeJsonDataSource(),
      recipeLocalDataStore: RecipeLocalDataStoreImpl()
    )
    return await RecipeViewModel(
      repository: repository,
      favoritedRecipeRepository: repository
    )
  }

  func test_GetAllRecipes() async {
    let sut = await makeSUT()
    await sut.update(titleSearch: "")
    await sut.getRecipes()
    try! await Task.sleep(nanoseconds: 100_000_000)
    let recipes = await sut.recipes
    XCTAssertEqual(recipes.count, 3)
  }

  func test_GetGarlicLemonChickenRecipe() async {
    let title = "Garlic Lemon Chicken"
    let sut = await makeSUT()
    await sut.update(titleSearch: title)
    await sut.getRecipes()
    try! await Task.sleep(nanoseconds: 100_000_000)
    let recipes = await sut.recipes
    XCTAssertEqual(recipes.count, 1)
    XCTAssertEqual(recipes.first!.title, title)
  }

  func test_GetVeggiePastaPrimaveraRecipe() async {
    let title = "Veggie Pasta Primavera"
    let sut = await makeSUT()
    await sut.update(titleSearch: title)
    await sut.getRecipes()
    try! await Task.sleep(nanoseconds: 100_000_000)
    let recipes = await sut.recipes
    XCTAssertEqual(recipes.count, 1)
    XCTAssertEqual(recipes.first!.title, title)
  }

  func test_GetOvernightOatsRecipe() async {
    let title = "Overnight Oats"
    let sut = await makeSUT()
    await sut.update(titleSearch: title)
    await sut.getRecipes()
    try! await Task.sleep(nanoseconds: 100_000_000)
    let recipes = await sut.recipes
    XCTAssertEqual(recipes.count, 1)
    XCTAssertEqual(recipes.first!.title, title)
  }

}
