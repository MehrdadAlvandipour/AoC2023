//
//  d3.swift
//  AoC23
//
//  Created by Mehrdad Alvandipour on 12/29/23.
//

import Foundation



struct Day3 {
    let filename = "/Users/mehrdad/workspace/swift_projects/AoC23/Day3/input.txt"
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
    
    func partOne() -> Int {
        var eng =  engSchema(lines: lines)
        return eng.partOne()
    }
    
    func partTwo() -> Int {
        var eng =  engSchema(lines: lines)
        return eng.partTwo()
    }
    
    struct Loc : Hashable {
        var row: Int
        var col: Int
    }
    
    struct engSchema {
        var lines: [String.SubSequence] = []
        var memo: [Loc: Character] = [:]
        var visited: Set<Loc> = []
        var lastRow: Int = -1
        var lastCol: Int = -1
        
        init(lines: [String.SubSequence]) {
            self.lines = lines
            lastRow = lines.count - 1
            lastCol = lines[0].count - 1
        }
        
        func readLocationFromLines(r:Int, c:Int) -> Character {
            let colIdx = String.Index(utf16Offset: c, in: lines[r])
            return (lines[r][colIdx])
        }
        
        mutating func readFromMemo(r:Int, c:Int) -> Character {
            if let x = memo[Loc(row: r, col: c)] {
                return x
            } else {
                memo[Loc(row: r, col: c)] = readLocationFromLines(r: r, c: c)
            }
            return memo[Loc(row: r, col: c)]!
        }
        
        mutating func isSymbol(r:Int, c:Int) -> Bool {
            let x = readFromMemo(r: r, c: c)
            return !(x.isNumber || (x == "."))
        }
        
        mutating func hasSymbolNeighbor(r:Int, c:Int) -> Bool {
            for dr in [-1, 0, +1] {
                for dc in [-1, 0, +1] {
                    if (0 <= r+dr && r+dr < lastRow) && (0 <= c+dc && c+dc < lastCol) {
                        if isSymbol(r: r+dr, c: c+dc) {
                            return true
                        }
                    }
                }
            }
            return false
        }
        
        func shouldCeck(r:Int, c:Int) -> Bool {
            return !visited.contains(Loc(row: r, col: c))
        }
        
        mutating func visitRight(r: Int, c: Int) -> String {
            var c = c
            var rightDigits = ""
            while c <= lastCol && readLocationFromLines(r: r, c: c).isNumber {
                visited.insert(Loc(row: r, col: c))
                rightDigits.append(readLocationFromLines(r: r, c: c))
                c += 1
            }
            return rightDigits
        }
        
        func visitLeft(r: Int, c: Int) -> String {
            var c = c - 1
            var leftDigits = ""
            while c >= 0 && readLocationFromLines(r: r, c: c).isNumber {
                //            visited.insert(Loc(row: r, col: c))
                leftDigits.insert(readLocationFromLines(r: r, c: c), at: leftDigits.startIndex)
                c -= 1
            }
            return leftDigits
        }
        
        mutating func visitAndRead(r: Int, c: Int) -> Int {
            return Int(visitLeft(r: r, c: c) + visitRight(r: r, c: c))!
        }
        
        
        mutating func partOne() -> Int {
            var magicNums: [Int] = []
            for (r, line) in lines.enumerated() {
                for (c,char) in line.enumerated() {
                    if (char.isNumber && shouldCeck(r: r, c: c) && hasSymbolNeighbor(r: r, c: c)) {
                        magicNums.append(visitAndRead(r: r, c: c))
                    }
                }
                
            }
            return (magicNums.reduce(0, +))
        }
        
        mutating func readWholeNumber(at location: Loc) -> Int {
            return visitAndRead(r: location.row, c: location.col)
        }
        
        mutating func visitForRatio(r: Int, c: Int) -> Int? {
            var count = 0
            var currentRatio = 1
            for dr in [-1, 0, +1] {
                for dc in [-1, 0, +1] {
                    if (0 <= r+dr && r+dr <= lastRow) &&
                        (0 <= c+dc && c+dc <= lastCol) &&
                        (readLocationFromLines(r: r+dr, c: c+dc).isNumber) &&
                        shouldCeck(r: r+dr, c: c+dc) {
                        currentRatio = currentRatio * visitAndRead(r: r+dr, c: c+dc)
                        count += 1
                        if count > 2 {
                            visited = []
                            return nil
                        }
                    }
                }
            }
            if count == 2 {
                visited = []
                return currentRatio
            } else {
                visited = []
                return nil
            }
        }
        
        mutating func partTwo() -> Int {
            var gearRatios: [Int] = []
            for (r, line) in lines.enumerated() {
                for (c,char) in line.enumerated() {
                    if char == "*" {
                        if let ratio = visitForRatio(r: r, c: c) {
                            gearRatios.append(ratio)
                        }
                    }
                }
            }
            return (gearRatios.reduce(0, +))
        }
    }
}
