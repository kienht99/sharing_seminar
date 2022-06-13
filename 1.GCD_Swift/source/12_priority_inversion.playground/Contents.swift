import UIKit

enum Color: String {
    case blue = "🔵"
    case white = "⚪️"
}

func output(color: Color, times: Int) {
    for _ in 1...times {
        print(color.rawValue)
    }
}

let starterQueue = DispatchQueue(label: "StdioHue.starter", qos: .userInteractive)
let utilityQueue = DispatchQueue(label: "StdioHue.utility", qos: .utility)
let backgroundQueue = DispatchQueue(label: "StdioHue.background", qos: .background)
let count = 10

starterQueue.async {
    
    utilityQueue.async {
        output(color: .blue, times: count)
    }
    
    backgroundQueue.async {
        output(color: .white, times: count)
    }
    
//    backgroundQueue.async {}
}
