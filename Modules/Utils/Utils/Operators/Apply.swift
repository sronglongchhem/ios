import Foundation

precedencegroup ForwardApplication {
  associativity: left
}

precedencegroup BackwardApplication {
  associativity: right
}

infix operator |>: ForwardApplication
infix operator <|: BackwardApplication

public func |> <A, B>(argument: A, function: (A) -> B) -> B {
  return function(argument)
}

public func <| <A, B>(function: (A) -> B, argument: A) -> B {
  return function(argument)
}
