//
//  MainDependencyContainer.swift
//  RecipeBuddy
//
//  Created by Daniel Prastiwa on 13/08/25.
//

import Foundation
import RebudData
import BZConnectionChecker
import BZUtil


@MainActor
final class MainDependencyContainer {

  let connectionReachabilityModel: ConnectionReachabilityModel
  let connectionReachability: ConnectionReachability
  let networkConnectionChecker: NetworkConnectionChecker
  let recipeLocalDataStore: RecipeLocalDataStore
  let mainViewModel: MainViewModel

  init() {
    func makeRecipeLocalDataStore() -> RecipeLocalDataStore {
      return RecipeLocalDataStoreImpl()
    }

    func makeConnectionReachability() -> ConnectionReachability { ConnectionReachability() }

    func makeConnectionReachabilityModel(
      connReachability: ConnectionReachability,
      networkConnectionChecker: NetworkConnectionChecker
    ) -> ConnectionReachabilityModel {
      ConnectionReachabilityModel(connectionReachability: connReachability)
    }

    func makeNetworkConnectionChecker(connReachability: ConnectionReachability) -> NetworkConnectionChecker {
      NetworkConnectionCheckerImpl(reachability: connReachability)
    }

    func makeMainViewModel() -> MainViewModel {
      MainViewModel()
    }

    let recipeLocalDataStore = makeRecipeLocalDataStore()
    let connectionReachability = makeConnectionReachability()
    self.connectionReachability = connectionReachability
    self.recipeLocalDataStore = recipeLocalDataStore
    self.networkConnectionChecker = makeNetworkConnectionChecker(connReachability: connectionReachability)
    self.connectionReachabilityModel = makeConnectionReachabilityModel(
      connReachability: connectionReachability,
      networkConnectionChecker: networkConnectionChecker
    )
    self.mainViewModel = makeMainViewModel()
  }

  func makeRecipeViewModel() -> RecipeViewModel {
    let recipeRemoteDataSource = RecipeJsonDataSource()
    let recipeRepository = RecipeRepositoryImplementation(
      networkConnectionChecker: self.networkConnectionChecker,
      recipeRemoteDataSource: recipeRemoteDataSource,
      recipeLocalDataStore: self.recipeLocalDataStore
    )
    return RecipeViewModel(
      repository: recipeRepository,
      favoritedRecipeRepository: recipeRepository
    )
  }

}
