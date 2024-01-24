//
//  d4.swift
//  AoC23
//
//  Created by Mehrdad Alvandipour on 12/29/23.
//

import Foundation


struct Day4 {
    let filename = "/Users/mehrdad/workspace/swift_projects/AoC23/Day4/input.txt"
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
    
    func countMatchs(from m: Set<Int>, to w: Set<Int>) -> Int? {
        var count = 0
        for c in m {
            count += w.contains(c) ? 1 : 0
        }
        return count > 0 ? count : nil
    }
    
    func getScore(from m: Set<Int>, to w: Set<Int>) -> Int {
        var score = 0
        if let c = countMatchs(from: m, to: w) {
            score = 1 * Int(pow(Double(2), Double(c-1)))
        }
        return score
    }
    
    func partOne() -> Int {
        var totalScore = 0
        for line in lines {
//            print(line)
            let cards = line.split(separator: ":")[1].split(separator: "|")
            let winningCards = Set(cards[0].split(separator: " ").map { Substring in
                Int(Substring)!
            })
            let myCards = Set(cards[1].split(separator: " ").map { Substring in
                Int(Substring)!
            })
            
            totalScore += getScore(from: myCards, to: winningCards)
        }
        return (totalScore)
    }
    
    func getMatchCount(of line: String.SubSequence) -> Int {
        let cards = line.split(separator: ":")[1].split(separator: "|")
        let winningCards = Set(cards[0].split(separator: " ").map { Substring in
            Int(Substring)!
        })
        let myCards = Set(cards[1].split(separator: " ").map { Substring in
            Int(Substring)!
        })
        
        return countMatchs(from: myCards, to: winningCards) ?? 0
    }
    func partTwo() -> Int {
//        var matchCounts: [Int] = []
        var instances = [Int] (repeating: 1, count: lines.count)
        for (i, line) in lines.enumerated() {
            let c = getMatchCount(of: line)
            if c == 0 {continue}
            for j in 1...c {
                
                if i + j < lines.count {
                    instances[i+j] +=  instances[i]
                }
                
            }
//            matchCounts.append(c)
        }
        return (instances.reduce(0, +))
//        print(matchCounts)
    }
}
