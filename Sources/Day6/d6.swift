//
//  d6.swift
//  AoC23
//
//  Created by Mehrdad Alvandipour on 12/30/23.
//

import Foundation



struct Day6 {
    let filename = "/Users/mehrdad/workspace/swift_projects/AoC23/Day6/input.txt"
    var lines: [String.SubSequence] = []
    var times: [Int] = []
    var distances: [Int] = []
    
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
        times = lines[0].split(separator: ":")[1].split(separator: " ").map { Substring in
            Int(Substring)!
        }
        distances = lines[1].split(separator: ":")[1].split(separator: " ").map { Substring in
            Int(Substring)!
        }
    }
    
    init(input: String) {
        let contents = input
        lines = (contents).split(separator:"\n")
        times = lines[0].split(separator: ":")[1].split(separator: " ").map { Substring in
            Int(Substring)!
        }
        distances = lines[1].split(separator: ":")[1].split(separator: " ").map { Substring in
            Int(Substring)!
        }
    }
    
    func solveQuad(t: Int,d: Int) -> (Double, Double){
        let delta = sqrt(Double(t*t - 4 * d))
        var left: Double = (Double(t) - delta) / 2
        var right: Double = (Double(t) + delta) / 2
        left.round(FloatingPointRoundingRule.up)
        right.round(FloatingPointRoundingRule.down)
        left = max(left, 0)
        right = min(right, Double(t))
        return (left, right)
    }
    
    func partOne() -> Double {
        var list: [Double] = []
        for (t,d) in zip(times, distances) {
            let delta = sqrt(Double(t*t - 4 * d))
            var left: Double = (Double(t) - delta) / 2
            var right: Double = (Double(t) + delta) / 2
//            print(left, right)
            left += 1
            right -= 1
            left.round(FloatingPointRoundingRule.down)
            right.round(FloatingPointRoundingRule.up)
//            print(left, right)
            left = max(left, 0)
            right = min(right, Double(t))
            list.append(right - left + 1)
        }
        print(list)
        return (list.reduce(1, *))
    }
    
    func partTwo() -> Double {
        let t = Int(times.reduce("", { partialResult, x in
            partialResult + String(x)
        }))!
        let d = Int(distances.reduce("", { partialResult, x in
            partialResult + String(x)
        }))!
        
        let (left, right) = solveQuad(t: t, d: d)
        return (right - left + 1)
    }
    
//    func sol() {
//        partTwo()
//    }
    
    
}
