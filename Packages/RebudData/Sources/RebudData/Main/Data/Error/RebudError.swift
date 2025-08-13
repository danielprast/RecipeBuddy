//
//  RebudError.swift
//  RebudData
//
//  Created by Daniel Prastiwa on 13/08/25.
//

import Foundation


public enum RebudError: LocalizedError, Equatable {

  case custom(String)
  case emptyResult
  case connectionProblem
  case parsingError
  case internalServerError

  public var errorMessage: String {
    switch self {
    case let .custom(msg):
      return msg
    case .internalServerError:
      return "Internal Server Error"
    case .parsingError:
      return "Something went wrong. Please try again later."
    case .connectionProblem:
      return "Please check your network connection"
    case .emptyResult:
      return "Data not found"
    }
  }

  public static func ==(lhs: RebudError, rhs: RebudError) -> Bool {
    switch (lhs, rhs) {
    case (custom(let lhsMessage), custom(let rhsMessage)):
      lhsMessage == rhsMessage
    case (internalServerError, internalServerError):
      true
    case (parsingError, parsingError):
      true
    case (connectionProblem, connectionProblem):
      true
    case (emptyResult, emptyResult):
      true
    default:
      false
    }
  }
}
