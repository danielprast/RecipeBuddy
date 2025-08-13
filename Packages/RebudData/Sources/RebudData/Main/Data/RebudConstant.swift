//
//  RebudConstant.swift
//  RebudData
//
//  Created by Daniel Prastiwa on 13/08/25.
//

import Foundation

public struct RebudConstant {

  public init() {}

  public static func apikey() -> String {
    Bundle.main.object(forInfoDictionaryKey: "APIKEY") as! String
  }

  public static func baseUrl() -> String {
    Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as! String
  }

}
