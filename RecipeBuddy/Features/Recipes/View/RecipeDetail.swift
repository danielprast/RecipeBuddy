//
//  RecipeDetail.swift
//  RecipeBuddy
//
//  Created by Daniel Prastiwa on 13/08/25.
//

import SwiftUI
import RebudData
import BZConnectionChecker
import BZUtil


struct RecipeDetail: View {

  @ObservedObject var recipeData: RecipeViewModel

  var isFavorite: Bool {
    guard let recipeDetail = recipeData.detailRecipe else {
      return false
    }
    return recipeData.checkFavorite(recipeDetail)
  }

  var body: some View {
    VStack {
      Text("Detail Recipe")
      Button {
        guard let recipeDetail = recipeData.detailRecipe else {
          return
        }
        recipeData.handleFavorite(recipeDetail)
      } label: {
        if isFavorite {
          Label(
            "Remove Favorite",
            systemImage: "star.circle.fill"
          )
          .foregroundStyle(Color.blue)
        } else {
          Label(
            "Add to Favorite",
            systemImage: "star.circle.fill"
          )
          .foregroundStyle(Color.gray)
        }
      }
    }
    .navigationTitle(recipeData.detailRecipeTitle)
  }
}
