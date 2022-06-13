import UIKit

// Define number of tasks
let concurrentTasks = 4

// Create Concurrent Queue
let queue = DispatchQueue(label: "StdioHue.Semaphore", attributes: .concurrent)

// Create Semaphore object
let semaphore = DispatchSemaphore(value: concurrentTasks)

for i in 0 ... 10 {
    // Async Tasks
    queue.async {
        semaphore.wait()
        defer { semaphore.signal() }
        print("Bắt đầu \(i)")
        // Simulate a network wait
        Thread.sleep(forTimeInterval: 3)
        print("Kết thúc \(i)")
    }
}
