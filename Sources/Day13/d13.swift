//
//  d13.swift
//  AoC23
//
//  Created by Mehrdad Alvandipour on 1/3/24.
//

import Foundation


struct Day13 {
    static let filename = "/Users/mehrdad/workspace/swift_projects/AoC23/Day13/input.txt"
    let lines: [String.SubSequence]
    
    static func readfile() -> String {
        var contents : String
        contents = (try? String(contentsOfFile: filename)) ?? ""
        if contents == "" {
            print("failed to read file")
        }
        return contents
    }
    
    init() {
        let contents = Day13.readfile()
        lines = contents.split(omittingEmptySubsequences: false) { $0.isNewline }
    }
    
    init(input: String) {
        let contents = input
        lines = contents.split(omittingEmptySubsequences: false) { $0.isNewline }
    }
    
    
    func intEncode(_ table: [some StringProtocol]) -> (h: [Int],v: [Int] ){
        var hSums = [Int](repeating: 0, count: table.count)
        var vSums = [Int](repeating: 0, count: table[0].count)
        for (i,l) in table.enumerated() {
            for (j,ch) in l.enumerated() {
                if ch == "#" {
                    hSums[i] += (1 << j)
                    vSums[j] += (1 << i)
                }
            }
        }
        return (hSums, vSums)
    }
    
    func reflectionLine(of pattern: [Int], smudge: Int) -> Int {
        for index in pattern.indices where index + 2 <= pattern.count {
            if (pattern[index] ^ pattern[index+1]).nonzeroBitCount <= smudge {
                var left = pattern[0...index]
                var right = pattern[(index+1)...]
                if left.count < right.count {
                    right = right.prefix(left.count)
                } else if left.count > right.count {
                    left = left.suffix(right.count)
                }
                let err = zip(Array(left),right.reversed()).map { ($0.0 ^ $0.1).nonzeroBitCount }
                    .reduce(0, +)
                if err == smudge {return index + 1}
            }
        }
        return 0
    }
    
    func partOne() -> Int {
        return computeScore(smudge: 0)
    }
    
    func partTwo() -> Int {
        return computeScore(smudge: 1)
    }
    
    func computeScore(smudge: Int) -> Int {
        let slices = lines.slices() { $0.isEmpty }
        var total = 0
        for pat in slices {
            let (h,v) = intEncode(pat)
            var refLineScore = reflectionLine(of: v, smudge: smudge)
            if refLineScore == 0 {
                refLineScore += reflectionLine(of: h, smudge: smudge) * 100
            }
            total += refLineScore
        }
        return total
    }
 
    func sol() {
        
        print(partTwo())

        
        
    }
}

private extension Array where Element: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        if lhs.count != rhs.count {return false}
        for (i,n) in lhs.enumerated() {
            if n != rhs[i] { return false}
        }
        return true
    }
}

private extension Array{
    func slices(by cond: (Element)->Bool) -> [[Element]] {
        var s: [Element] = []
        var result: [[Element]] = []
        for item in self {
            if cond(item) {
                result.append(s)
                s.removeAll()
            } else {
                s.append(item)
            }
        }
        if !s.isEmpty {
            result.append(s)
        }
        return result
    }
}
