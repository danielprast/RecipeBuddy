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

  @EnvironmentObject var connectionModel: ConnectionReachabilityModel
  @ObservedObject var recipeData: RecipeViewModel
  @State var counter = 0

  init(recipeData: RecipeViewModel) {
    self.recipeData = recipeData
  }

  var body: some View {
    ZStack {
      if recipeData.isLoadingGetRecipes {
        ProgressView()
      } else {
        if let error = recipeData.getRecipesError {
          ErrorView(message: error.errorMessage)
        } else {
          if recipeData.recipes.isEmpty {
            ErrorView(message: "No recipes found!")
          } else {
            RecipeListView(recipeData: recipeData)
              .environmentObject(connectionModel)
          }
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .navigationTitle("Recipes")
    .searchable(text: $recipeData.titleSearch, prompt: "Recipe name...")
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
        RecipeItem(
          recipe: recipe,
          isFavorite: recipeData.checkFavorite(recipe)
        )
        .frame(maxWidth: .infinity, maxHeight: 56)
        .cornerRadius(8)
        .onTapGesture {
          recipeData.detailRecipe = recipe
          recipeData.presentNext(route: .RecipeDetail)
        }
        .swipeActions {
          Button(role: .none) {
            recipeData.addToFavorite(recipe)
          } label: {
            Label("Add to Favorite", systemImage: "star.circle.fill")
          }
        }
      }
    }
  }
}


struct RecipeItem: View {

  let recipe: RecipeEntity
  let isFavorite: Bool

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(recipe.title)
          .font(.body)
        Text("\(recipe.minutes) minutes")
          .font(.caption)
      }
      Spacer()
      if isFavorite {
        Image(systemName: "star.circle.fill")
          .resizable()
          .frame(width: 24, height: 24)
          .foregroundStyle(Color.blue)
      }
    }
  }

}
