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

  func testFetchRecipesJson() async {
    do {
      let result = try await sut.fetchRecipes()
      XCTAssertTrue(!result.isEmpty)
    } catch {
      print("Failed to fetch recipes")
    }
  }

}
