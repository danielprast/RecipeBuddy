//
//  ContentView.swift
//  RecipeBuddy
//
//  Created by Daniel Prastiwa on 12/08/25.
//

import SwiftUI
import RebudData
import BZConnectionChecker


struct MainView: View {

  let dependencyContainer: MainDependencyContainer
  @EnvironmentObject var connectionModel: ConnectionReachabilityModel

  init(dependencyContainer: MainDependencyContainer) {
    self.dependencyContainer = dependencyContainer
  }

  var body: some View {
    RecipeNavigation(dependencyContainer: dependencyContainer)
  }
}
