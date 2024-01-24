//
//  d9.swift
//  AoC23
//
//  Created by Mehrdad Alvandipour on 12/31/23.
//

import Foundation


struct Day9 {
    let filename = "/Users/mehrdad/workspace/swift_projects/AoC23/Day9/input.txt"
    var lines: [String.SubSequence] = []
    
    func readfile() -> String {
        var contents : String
        contents = (try? String(contentsOfFile: filename)) ?? ""
        if contents == "" {
            print("failed to read file")
        }
        return contents
    }
    
    init() {
        let contents = readfile()
        lines = (contents).split(separator:"\n")
    }
    
    init(input: String) {
        let contents = input
        lines = (contents).split(separator:"\n")
    }
    
    func diff(nums: [Int]) -> [Int] {
        var out = [Int](repeating: 0, count: nums.count-1)
        for i in 0...nums.count-2 {
             out[i] = nums[i+1] - nums[i]
        }
        return out
    }
    
    func allEqual(_ nums: [Int]) -> Bool {
        let item = nums[0]
        for x in nums {
            if x  != item {
                return false
            }
        }
        return true
    }
    func predict(_ nums :[Int]) -> Int{
        if allEqual(nums) {
            return nums[0]
        }
        let d = predict(diff(nums: nums))
        return nums.last! + d
    }
    
    func numsArray(from line: String) -> [Int] {
        return line.split(separator: " ").map { Int($0)! }
    }
    
    func partOne() -> Int{
        var predSum = 0
        for line in lines {
            let x = numsArray(from: String(line))
            predSum += predict(x)
        }
        return (predSum)
    }
    
    func partTwo() -> Int {
        var predSum = 0
        for line in lines {
            let x = numsArray(from: String(line))
            predSum += predict(x.reversed())
        }
        return (predSum)
    }
}
