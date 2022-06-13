import UIKit

let queue = DispatchQueue(label: "StdioHue")

queue.sync {
    print("Task 1 begin")
    Thread.sleep(forTimeInterval: 3)
    print("Task 1 done")
}

print("Task 2 begin")
Thread.sleep(forTimeInterval: 2)
print("Task 2 done")

/*
 Task 1 begin
 Task 1 done
 Task 2 begin
 Task 2 done
 */
