//
//  d18.swift
//  AoC23
//
//  Created by Mehrdad Alvandipour on 1/21/24.
//

import Foundation


struct Day18 {
    let filename = "/Users/mehrdad/workspace/swift_projects/AoC23/Day18/input.txt"
    let lines: [String.SubSequence]
    
    init() {
        let contents = readfile(filename)
        lines = contents.split(omittingEmptySubsequences: true) { $0.isNewline }
    }
    
    init(input: String) {
        let contents = input
        lines = contents.split(omittingEmptySubsequences: true) { $0.isNewline }
    }
    
    struct Tuple {
        let i,j: Int
        
        init(_ i: Int, _ j: Int) {
            self.i = i
            self.j = j
        }
        
        static func *(lhs: Self, scalar: Int) -> Self {
            return Tuple(lhs.i * scalar, lhs.j * scalar)
        }
        
        static func +(lhs: Self, rhs: Self) -> Self {
            return Tuple(lhs.i + rhs.i, lhs.j + rhs.j)
        }
    }
    
    func shoelace_formula(_ v: [Tuple]) -> Int {
        let n = v.count
        return abs(v.enumerated().map { (i, p) in
            p.i * v[(i+1) % n].j -  v[(i+1) % n].i * p.j
        }.reduce(0, +)) / 2
    }
    
    func partOneParser(line: Substring ) -> (step: Int, dir: Tuple) {
        let dirMap: [String:Tuple] = [
            "R": Tuple(0,1),
            "D": Tuple(1,0),
            "L": Tuple(0,-1),
            "U": Tuple(-1,0)
        ]
        let lineSplit = line.split(separator: " ")
        let (dir, step) = (dirMap[String(lineSplit[0])]!, Int(lineSplit[1])!)
        return (step, dir)
    }
    
    func partTwoParser(_ line: Substring ) -> (step: Int, dir: Tuple) {
        let dirMap: [Character:Tuple] = [
            "0": Tuple(0,1),
            "1": Tuple(1,0),
            "2": Tuple(0,-1),
            "3": Tuple(-1,0)
        ]
        let lineSplit = line.split(separator: " ")
        let hexCode = lineSplit[2].trimmingCharacters(in: ["(", ")", "#"])
        let (step, dir) = (Int(hexCode.dropLast(1), radix: 16)!, dirMap[hexCode.last!]!)
        return (step, dir)
    }
    
    func parseAndSolve(parser: (Substring) -> (Int, Tuple)) -> Int {
        var vertices: [Tuple] = [Tuple(0,0)]
        var boundaryCells = 0
        for line in lines {
            let (step, dir) = parser(line)
            vertices.append(  vertices.last! + (dir * step))
            boundaryCells += step
        }
        let A = shoelace_formula(vertices)
        let i = A - (boundaryCells/2) + 1 // Pick's Theorem
        return (i + boundaryCells)
    }
    
    func partOne() -> Int {
        parseAndSolve(parser: partOneParser)
    }
    
    func partTwo() -> Int {
        parseAndSolve(parser: partTwoParser)
    }
}


