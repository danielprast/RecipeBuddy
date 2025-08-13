//
//  RecipeRemoteDataSourceTest.swift
//  RebudData
//
//  Created by Daniel Prastiwa on 13/08/25.
//

import XCTest
@testable import RebudData


final class RecipeRemoteDataSourceTest: XCTestCase {

  var sut: RecipeRemoteDataSource!

  override func setUp() {
    super.setUp()
    sut = makeSUT()
  }

  func makeSUT() -> RecipeRemoteDataSource {
    RecipeJsonDataSource()
  }

  func test_FetchRecipesJsonWithNoParam_ReturnAllRecipes() async {
    do {
      let result = try await sut.fetchRecipes(title: "")
      XCTAssertTrue(!result.isEmpty)
    } catch {
      print("Failed to fetch recipes")
    }
  }

  func test_FetchRecipesJsonWithParamTitleVeggiePasta_ReturnFilteredRecipes() async {
    do {
      let result = try await sut.fetchRecipes(title: "Veggie Pasta")
      XCTAssertEqual(result.first!.id, "r2")
    } catch {
      print("Failed to fetch recipes")
    }
  }

}
