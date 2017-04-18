//
//  main.swift
//  SortingAlgorithm
//
//  Created by Art Huang on 18/04/2017.
//  Copyright © 2017 Art Huang. All rights reserved.
//

import Foundation

let ascending: ComparingBlock = { $0 - $1 }
var descending: ComparingBlock = { -ascending($0, $1) }

struct Settings {
    static let Max = 5000
    static let order: ComparingBlock = descending
}

extension MutableCollection where Indices.Iterator.Element == Index {
    // Shuffle the contents of this collection
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    // Returns an array with the contents of this sequence, shuffled
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

func evaluateTimeAndResult(_ numsForSort: [Int], perform sort: SortingBlock) -> [Int] {
    let start = DispatchTime.now()
    let result = sort(numsForSort, Settings.order)
    let end = DispatchTime.now()
    
    var succeed = true
    let golden = (Settings.order(0, 1) <= 0) ? Array(1...Settings.Max) : Array((1...Settings.Max).reversed())
    
    for i in 0..<Settings.Max {
        guard result[i] == golden[i] else {
            succeed = false
            break
        }
    }
    
    if succeed {
        print("done")
    }
    else {
        print("failed")
    }
    
    let timeInterval = Double(end.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000
    print("Using time \(timeInterval) ms")
    return result
}


// Prepare test numbers
let randomNums = Array(1...Settings.Max).shuffled()
print("Bubble sort...", separator: "", terminator: "")
_ = evaluateTimeAndResult(randomNums, perform: SortingAlgorithm.bubbleSort)
print("Selection sort...", separator: "", terminator: "")
_ = evaluateTimeAndResult(randomNums, perform: SortingAlgorithm.selectionSort)
print("Insertion sort...", separator: "", terminator: "")
_ = evaluateTimeAndResult(randomNums, perform: SortingAlgorithm.insertionSort)
print("Quicksort...", separator: "", terminator: "")
_ = evaluateTimeAndResult(randomNums, perform: SortingAlgorithm.quicksort)
print("Randomized Quicksort...", separator: "", terminator: "")
_ = evaluateTimeAndResult(randomNums, perform: SortingAlgorithm.randomizedQuicksort)
print("Radix sort...", separator: "", terminator: "")
_ = evaluateTimeAndResult(randomNums, perform: SortingAlgorithm.radixSort)
