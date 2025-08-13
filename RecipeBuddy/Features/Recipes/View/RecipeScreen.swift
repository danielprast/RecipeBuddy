//
//  RecipeScreen.swift
//  RecipeBuddy
//
//  Created by Daniel Prastiwa on 13/08/25.
//

import SwiftUI
import RebudData
import BZConnectionChecker
import BZUtil


struct RecipeScreen: View {

  let dependencyContainer: MainDependencyContainer
  @EnvironmentObject var connectionModel: ConnectionReachabilityModel
  @StateObject var recipeData: RecipeViewModel
  @State var counter = 0

  init(dependencyContainer: MainDependencyContainer) {
    self.dependencyContainer = dependencyContainer
    _recipeData = StateObject(wrappedValue: dependencyContainer.makeRecipeViewModel())
  }

  var body: some View {
    ZStack {
      if let error = recipeData.getRecipesError {
        Text(error.errorMessage)
          .padding()
      } else {
        if recipeData.recipes.isEmpty {
          Text("No recipes found!")
            .padding()
        } else {
          RecipeListView(recipeData: recipeData)
            .environmentObject(connectionModel)
        }
      }
    }
    .onReceive(
      connectionModel.$isInternetAvailable,
      perform: { isAvailable in
        guard isAvailable else { return }
        recipeData.getInitialRecipes()
      }
    )
  }
}


struct RecipeListView: View {

  @EnvironmentObject var connectionModel: ConnectionReachabilityModel
  @ObservedObject var recipeData: RecipeViewModel

  init(recipeData: RecipeViewModel) {
    self.recipeData = recipeData
  }

  var body: some View {
    List {
      ForEach(recipeData.recipes, id: \.id) { recipe in
        VStack(alignment: .leading) {
          Text(recipe.title)
            .font(.body)
          Text("\(recipe.minutes) minutes")
            .font(.caption)
        }
        .swipeActions {
          Button(role: .none) {
            clog("add to favorites", "...")
          } label: {
            Label("Add to Favorite", systemImage: "star.circle.fill")
          }
        }
      }
    }
  }
}
