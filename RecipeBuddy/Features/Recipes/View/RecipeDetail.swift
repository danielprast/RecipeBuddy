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

  var body: some View {
    VStack {
      Text("Detail Recipe")
    }
    .navigationTitle(recipeData.detailRecipeTitle)
  }
}
