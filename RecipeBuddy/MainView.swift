//
//  ContentView.swift
//  RecipeBuddy
//
//  Created by Daniel Prastiwa on 12/08/25.
//

import SwiftUI
import RebudData

struct MainView: View {

  @EnvironmentObject var mainViewModel: MainViewModel

  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("APIKEY: \(RebudConstant.apikey())")
      Text("BaseURL: \(RebudConstant.baseUrl())")
    }
    .padding()
  }
}

#Preview {
  MainView()
}
