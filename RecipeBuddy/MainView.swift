//
//  ContentView.swift
//  RecipeBuddy
//
//  Created by Daniel Prastiwa on 12/08/25.
//

import SwiftUI

struct MainView: View {

  @EnvironmentObject var mainViewModel: MainViewModel

  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Recipe Buddy! Data: \(mainViewModel.unitName)")
    }
    .padding()
  }
}

#Preview {
  MainView()
}
