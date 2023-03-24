import UIKit
import Foundation

func foo(_ arg: String, _ x: Double) {
    guard let f = parseExpression(arg) else { print("Invalid Expression"); return }
    guard let y = f(x) else { print("nil"); return }
    print(y)
}

foo("x^3", 3)

