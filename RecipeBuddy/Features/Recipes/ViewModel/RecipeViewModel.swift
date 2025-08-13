//
//  RecipeViewModel.swift
//  RecipeBuddy
//
//  Created by Daniel Prastiwa on 13/08/25.
//

import Foundation
import RebudData
import BZUtil


@MainActor
final class RecipeViewModel: ObservableObject {

  let repository: RecipeRepository

  init(repository: RecipeRepository) {
    self.repository = repository
    clog("inited", "\(Self.self)")
  }

  @Published var routePath: [RecipeRoute] = []
  @Published var detailRecipe: RecipeEntity?
  @Published var recipes: [RecipeEntity] = []
  @Published var getRecipesError: RebudError?
  @Published var titleSearch: String = ""

  var detailRecipeTitle: String {
    detailRecipe?.title ?? ""
  }

  func update(titleSearch title: String) {
    titleSearch = title
  }

  func update(recipes: [RecipeEntity]) {
    self.recipes = recipes
  }

  func presentNext(route: RecipeRoute) {
    routePath.append(route)
  }

  func getInitialRecipes() {
    Task { [repository] in
      if !recipes.isEmpty {
        return
      }
      do {
        let entities = try await repository.getRecipes(title: titleSearch)
        update(recipes: entities)
      } catch {
        clog("get recipes error", error)
        getRecipesError = (error as! RebudError)
      }
    }
  }

  func getRecipes() {
    Task { [repository] in
      do {
        let entities = try await repository.getRecipes(title: titleSearch)
        update(recipes: entities)
      } catch {
        clog("get recipes error", error)
        getRecipesError = (error as! RebudError)
      }
    }
  }

}

// MARK: - •

enum RecipeRoute {
  case RecipeList
  case RecipeDetail
}
