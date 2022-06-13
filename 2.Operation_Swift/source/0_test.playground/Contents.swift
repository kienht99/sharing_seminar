import UIKit

class MyOperation: Operation {
    override func main() {
        for i in 0..<10 {
            print("🔴", i)
        }
    }
}

let myOperation = MyOperation()
myOperation.start()
