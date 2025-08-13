//
//  RecipeBuddyApp.swift
//  RecipeBuddy
//
//  Created by Daniel Prastiwa on 12/08/25.
//

import SwiftUI
import BZConnectionChecker

@main
struct RecipeBuddyApp: App {

  let mainDependencyContainer: MainDependencyContainer

  init() {
    let mainDC = MainDependencyContainer()
    mainDependencyContainer = mainDC
    _connectionModel = StateObject(wrappedValue: mainDC.connectionReachabilityModel)
    _mainViewModel = StateObject(wrappedValue: mainDC.mainViewModel)
  }

  @StateObject var mainViewModel: MainViewModel
  @StateObject var connectionModel: ConnectionReachabilityModel

  var body: some Scene {
    WindowGroup {
      MainView(dependencyContainer: self.mainDependencyContainer)
        .environmentObject(mainViewModel)
        .environmentObject(connectionModel)
    }
  }
}
