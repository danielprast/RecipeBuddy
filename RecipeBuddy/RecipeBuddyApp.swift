//
//  RecipeBuddyApp.swift
//  RecipeBuddy
//
//  Created by Daniel Prastiwa on 12/08/25.
//

import SwiftUI

@main
struct RecipeBuddyApp: App {

  @StateObject var mainViewModel = MainViewModel()

  var body: some Scene {
    WindowGroup {
      MainView()
        .environmentObject(mainViewModel)
    }
  }
}
