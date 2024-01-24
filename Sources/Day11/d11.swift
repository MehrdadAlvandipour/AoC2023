//
//  d11.swift
//  AoC23
//
//  Created by Mehrdad Alvandipour on 1/1/24.
//

import Foundation


private extension String {
    func index(at offset: Int) -> String.Index {
        index(startIndex, offsetBy: offset)
    }
    subscript(value: Int) -> Character {
        self[index(at: value)]
    }
}


struct Vec2: Hashable {
    let r: Int
    let c: Int
    
    init () {
        self.r = 0
        self.c = 0
    }
    
    init(_ r: Int, _ c: Int) {
        self.r = r
        self.c = c
    }
    
    static func +(lhs: Vec2, rhs: Vec2) -> Vec2 {
        return Vec2(lhs.r + rhs.r, lhs.c + rhs.c)
    }
    
    static func -(lhs: Vec2, rhs: Vec2) -> Vec2 {
        return Vec2(lhs.r - rhs.r, lhs.c - rhs.c)
    }
    
    func taxicab() -> Int {
        return abs(self.r) + abs(self.c)
    }
}

private extension Set<Int> {
    func intersectWtihInterval(_ ab: [Int]) -> Self {
        return self.intersectWtihInterval(lowerbound: ab.first!,
                                          upperBound: ab.last!)
    }
    func intersectWtihInterval(lowerbound: Int, upperBound: Int) -> Self {
        return self.filter { lowerbound <= $0 && $0 <= upperBound }
    }
}

struct Day11 {
    let filename = "/Users/mehrdad/workspace/swift_projects/AoC23/Day11/input.txt"
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
        var c = CosmicExpansion(lines: lines, expansionFactor: 2)
        return c.sol()
    }
    
    func partTwo() -> Int {
        var c = CosmicExpansion(lines: lines, expansionFactor: 1000000)
        return c.sol()
    }
    
    struct CosmicExpansion {
        let lines: [String.SubSequence]
        var width: Int = 0
        var height: Int = 0
        
        var expansionFactor = 2
        var galaxies: [Vec2] = []
        var rSet: Set<Int> = []
        var cSet: Set<Int> = []
        var emptyRows: [Int] = []
        var emptyCols: [Int] = []
        
        init(lines: [String.SubSequence], expansionFactor: Int = 2) {
            self.lines = lines
            self.height = lines.count
            self.width = lines[0].count
            self.expansionFactor = expansionFactor
        }
        mutating func findGalaxies() {
            for r in 0..<height {
                for c in 0..<width {
                    if String(lines[r])[c] != "." { // uses my private extension subscript for Strings
                        galaxies.append(Vec2(r,c))
                        rSet.insert(r)
                        cSet.insert(c)
                    }
                }
            }
        }
        
        
        mutating func findEmptySpaces() {
            emptyRows = (0..<height).filter { x in !rSet.contains(x) }
            emptyCols = (0..<width).filter { x in !cSet.contains(x) }
        }
        
        func spaceExpansions(g1: Vec2, g2: Vec2) -> Int {
            let rExpansionCount = Set(emptyRows).intersectWtihInterval([g1.r, g2.r].sorted()).count
            let cExpansionCount = Set(emptyCols).intersectWtihInterval([g1.c, g2.c].sorted()).count
            return (rExpansionCount + cExpansionCount) * (expansionFactor - 1)
        }
        
        func distBetween(g1: Vec2, g2:Vec2) -> Int {
            return (g1 - g2).taxicab() + spaceExpansions(g1: g1, g2: g2)
        }
        
        mutating func sol() -> Int {
//            print(height, width)
            findGalaxies()
            findEmptySpaces()
//            print("galaxies: \(galaxies.count)")
//            print("uniques: \(rSet.count), \(cSet.count)")
//            print("Empty rows: ", emptyRows.count)
//            print("Empty cols: ", emptyCols.count)

            var totalLength = 0
            for i in 0..<galaxies.count {
                for j in i+1..<galaxies.count {
                    let dist = distBetween(g1: galaxies[i], g2: galaxies[j])
                    totalLength += dist
                }
            }
            return (totalLength)
        }
    }
}




