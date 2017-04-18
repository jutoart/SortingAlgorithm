//
//  SortingAlgorithm.swift
//  SortingAlgorithm
//
//  Created by Art Huang on 28/03/2017.
//
//

//  Implement several kinds of sorting algorithms
//  Including: bubble sort, selection sort, insertion sort, quicksort, radix sort

import Foundation

typealias ComparingBlock = (Int, Int) -> Int
typealias SortingBlock = ([Int], ComparingBlock) -> [Int]

class SortingAlgorithm
{
    static func bubbleSort(_ inputNums: [Int], _ compare: ComparingBlock) -> [Int] {
        var nums = inputNums
        
        for i in (0..<nums.count).reversed() {
            for j in 0..<i {
                if compare(nums[j], nums[j+1]) > 0 {
                    swap(&nums[j], &nums[j+1])
                }
            }
        }
        
        return nums
    }
    
    static func selectionSort(_ inputNums: [Int], _ compare: ComparingBlock) -> [Int] {
        var nums = inputNums
        
        for i in 0..<nums.count-1 {
            for j in i+1..<nums.count {
                if compare(nums[i], nums[j]) > 0 {
                    swap(&nums[i], &nums[j])
                }
            }
        }
        
        return nums
    }
    
    static func insertionSort(_ inputNums: [Int], _ compare: ComparingBlock) -> [Int] {
        var nums = inputNums
        
        for i in 1..<nums.count {
            for j in (0..<i).reversed() {
                if compare(nums[j], nums[j+1]) > 0 {
                    swap(&nums[j], &nums[j+1])
                }
                else {
                    break
                }
            }
        }
        
        return nums
    }
    
    static func quicksort(_ inputNums: [Int], _ compare: ComparingBlock) -> [Int] {
        var nums = inputNums
        var stack = [(0, nums.count-1)]
        
        while !stack.isEmpty {
            let (p, q) = stack.popLast()!
            
            if p < q {
                var i = p
                
                for j in i+1...q {
                    if compare(nums[p], nums[j]) > 0 {
                        if i + 1 != j {
                            swap(&nums[i+1], &nums[j])
                        }
                        
                        i += 1
                    }
                }
                
                if p != i {
                    swap(&nums[p], &nums[i])
                }
                
                stack.append((p, i-1))
                stack.append((i+1, q))
            }
        }
        
        return nums
    }
    
    static func randomizedQuicksort(_ inputNums: [Int], _ compare: ComparingBlock) -> [Int] {
        var nums = inputNums
        var stack = [(0, nums.count-1)]
        
        while !stack.isEmpty {
            let (p, q) = stack.popLast()!
            
            if p < q {
                let r = numericCast(arc4random_uniform(numericCast(q - p))) + p
                
                if p != r {
                    swap(&nums[p], &nums[r])
                }
                
                var i = p
                
                for j in i+1...q {
                    if compare(nums[p], nums[j]) > 0 {
                        if i + 1 != j {
                            swap(&nums[i+1], &nums[j])
                        }
                        
                        i += 1
                    }
                }
                
                if p != i {
                    swap(&nums[p], &nums[i])
                }
                
                stack.append((p, i-1))
                stack.append((i+1, q))
            }
        }
        
        return nums
    }
    
    static func radixSort(_ inputNums: [Int], _ compare: ComparingBlock) -> [Int] {
        var nums = inputNums
        let bits = (MemoryLayout<Int>.size == MemoryLayout<Int64>.size) ? 64 : 32
        var shift = 0
        
        for _ in 0..<bits {
            var radix = [Int]()
            var sum = 0
            
            for i in 0..<nums.count {
                radix.append((nums[i] >> shift) & 0xf)
                sum += radix[i]
            }
            
            guard sum > 0 else { break }
            
            var count = Array(repeating: 0, count: 16)
            var buf = Array(repeating: 0, count: nums.count)
            
            for r in radix { count[r] += 1 }
            for r in 1...15 { count[r] += count[r-1] }
            
            for i in (0..<nums.count).reversed() {
                buf[count[radix[i]]-1] = nums[i]
                count[radix[i]] -= 1
            }
            
            shift += 4
            nums = buf
        }
        
        return (compare(0, 1) <= 0) ? nums : nums.reversed()
    }
}

