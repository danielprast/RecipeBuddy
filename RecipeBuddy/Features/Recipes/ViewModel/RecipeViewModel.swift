//
//  RecipeViewModel.swift
//  RecipeBuddy
//
//  Created by Daniel Prastiwa on 13/08/25.
//

import Foundation
import Combine
import RebudData
import BZUtil


@MainActor
final class RecipeViewModel: ObservableObject {

  let repository: RecipeRepository

  init(repository: RecipeRepository) {
    self.repository = repository
    clog("inited", "\(Self.self)")

    $titleSearch
      .debounce(
        for: .milliseconds(500),
        scheduler: RunLoop.main
      )
      .removeDuplicates()
      .sink { [weak self] value in
        self?.getRecipes()
      }
      .store(in: &cancellables)
  }

  @Published var routePath: [RecipeRoute] = []
  @Published var detailRecipe: RecipeEntity?
  @Published var recipes: [RecipeEntity] = []
  @Published var isLoadingGetRecipes: Bool = false
  @Published var getRecipesError: RebudError?
  @Published var titleSearch: String = ""

  private var cancellables = Set<AnyCancellable>()

  var detailRecipeTitle: String {
    detailRecipe?.title ?? ""
  }

  func update(titleSearch title: String) {
    titleSearch = title
  }

  func update(recipes: [RecipeEntity]) {
    self.recipes = recipes
  }

  func handleGetRecipeLoading(show: Bool) {
    isLoadingGetRecipes = show
  }

  // MARK: - • Navigation

  func presentNext(route: RecipeRoute) {
    routePath.append(route)
  }

  // MARK: - • Usecase

  func getInitialRecipes() {
    Task { [repository] in
      if !recipes.isEmpty {
        return
      }

      handleGetRecipeLoading(show: true)

      do {
        let entities = try await repository.getRecipes(title: titleSearch)
        handleGetRecipeLoading(show: false)
        update(recipes: entities)
      } catch {
        clog("get recipes error", error)
        getRecipesError = (error as! RebudError)
        handleGetRecipeLoading(show: false)
      }
    }
  }

  func getRecipes() {
    if isLoadingGetRecipes {
      return
    }

    handleGetRecipeLoading(show: true)

    Task { [repository] in
      do {
        let entities = try await repository.getRecipes(title: titleSearch)
        handleGetRecipeLoading(show: false)
        update(recipes: entities)
      } catch {
        clog("get recipes error", error)
        getRecipesError = (error as! RebudError)
        handleGetRecipeLoading(show: false)
      }
    }
  }

}

// MARK: - •

enum RecipeRoute {
  case RecipeList
  case RecipeDetail
}
