//
//  RecipeNavigation.swift
//  RecipeBuddy
//
//  Created by Daniel Prastiwa on 13/08/25.
//

import SwiftUI


struct RecipeNavigation: View {

  let dependencyContainer: MainDependencyContainer
  @StateObject var recipeData: RecipeViewModel

  init(dependencyContainer: MainDependencyContainer) {
    self.dependencyContainer = dependencyContainer
    _recipeData = StateObject(wrappedValue: dependencyContainer.makeRecipeViewModel())
  }

  var body: some View {
    NavigationStack(path: $recipeData.routePath) {
      RecipeScreen(recipeData: recipeData)
        .navigationDestination(for: RecipeRoute.self) { route in
          switch route {
          case .RecipeDetail:
            RecipeDetail(recipeData: recipeData)
          default:
            EmptyView()
          }
        }
    }
  }
}
