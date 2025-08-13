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
  let favoritedRecipeRepository: FavoritedRecipeRepository

  init(
    repository: RecipeRepository,
    favoritedRecipeRepository: FavoritedRecipeRepository
  ) {
    self.repository = repository
    self.favoritedRecipeRepository = favoritedRecipeRepository
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

    getFavoritedRecipes()
  }

  @Published var routePath: [RecipeRoute] = []
  @Published var detailRecipe: RecipeEntity?
  @Published var recipes: [RecipeEntity] = []
  @Published var isLoadingGetRecipes: Bool = false
  @Published var getRecipesError: RebudError?
  @Published var titleSearch: String = ""
  @Published var favoritedRecipes: [RecipeEntity] = []
  var favoritedRecipesReference: [String : RecipeEntity] = [:]

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

  func checkFavorite(_ recipe: RecipeEntity) -> Bool {
    favoritedRecipesReference[recipe.id] != nil
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

  func getFavoritedRecipes() {
    Task { [favoritedRecipeRepository] in
      async let favoritedRecipes = await favoritedRecipeRepository.getFavoritedRecipes()
      async let favoritedRecipesReference = await favoritedRecipeRepository.favoritedRecipes
      let tasks = await [favoritedRecipes, favoritedRecipesReference]
      self.favoritedRecipes = tasks[0] as! [RecipeEntity]
      self.favoritedRecipesReference = tasks[1] as! [String : RecipeEntity]
      clog("favorited recipes", self.favoritedRecipes)
    }
  }

  func addToFavorite(_ recipe: RecipeEntity) {
    Task { [favoritedRecipeRepository] in
      do {
        _ = try await favoritedRecipeRepository.addToFavorite(recipe)
        getFavoritedRecipes()
      } catch {
        clog("failed to add favorite recipe", (error as! RebudError).errorMessage)
      }
    }
  }

}

// MARK: - •

enum RecipeRoute {
  case RecipeList
  case RecipeDetail
}
