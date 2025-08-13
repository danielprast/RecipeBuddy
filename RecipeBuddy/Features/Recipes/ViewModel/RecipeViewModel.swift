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
  }

  @Published var recipes: [RecipeEntity] = []
  @Published var titleSearch: String = ""

  func update(titleSearch title: String) {
    titleSearch = title
  }

  func update(recipes: [RecipeEntity]) {
    self.recipes = recipes
  }

  func getRecipes() {
    Task { [repository] in
      do {
        let entities = try await repository.getRecipes(title: titleSearch)
        update(recipes: entities)
      } catch {
        clog("get recipes error", error)
      }
    }
  }

}
