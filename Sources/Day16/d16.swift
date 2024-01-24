//
//  d16.swift
//  AoC23
//
//  Created by Mehrdad Alvandipour on 1/7/24.
//

import Foundation


private enum Direction {
    case up,down,left,right
    
    static func +(lhs: (Int,Int), rhs: Self) -> (r: Int,c: Int) {
        let (row, col) = lhs
        switch rhs {
        case .down:
            return (row+1, col)
        case .right:
            return (row, col+1)
        case .up:
            return (row-1, col)
        case .left:
            return (row, col-1)
        }
    }
}

struct Photon: Hashable {
    let i: Int
    let j: Int
    fileprivate let dir: Direction
}

enum GridItem {
    case dot,backslash,foreslash, vert, dash
    
    fileprivate func cast(dir: Direction) -> [Direction] {
        var res: [Direction] = []
        switch self {
        case .dot:
            res.append(dir)
        case .backslash:
            switch dir {
            case .left:
                res.append(.up)
            case .up:
                res.append(.left)
            case .down:
                res.append(.right)
            case .right:
                res.append(.down)
            }
        case .foreslash:
            switch dir {
            case .left:
                res.append(.down)
            case .down:
                res.append(.left)
            case .up:
                res.append(.right)
            case .right:
                res.append(.up)
            }
        case .vert:
            switch dir {
            case .right, .left:
                res.append(contentsOf: [.up, .down])
            case .up:
                res.append(.up)
            case .down:
                res.append(.down)
            }
        case .dash:
            switch dir {
            case .up, .down:
                res.append(contentsOf: [.left, .right])
            case .left:
                res.append(.left)
            case .right:
                res.append(.right)
            }
        }
        return res
    }
}

struct contraption<Item> : CustomStringConvertible {
    let height: Int
    let width: Int
    let zero: Item
    let separator: String
    
    var data: [Item]
    var lit: [Int]
    
    var description: String {
        var line: [String] = []
        for i in 0..<height {
            let row = (0..<width).map { "\(self.lit[i*width + $0])" }
                .joined(separator: separator)
            line.append(row)
        }
        return line.joined(separator: "\n")
    }
    
    init(_ height: Int,_ width: Int, zero: Item, separtor: String=",") {
        self.height = height
        self.width = width
        self.zero = zero
        self.separator = separtor
        self.data = [Item](repeating: zero, count: width * height)
        self.lit = [Int](repeating: 0, count: width * height)
    }
    
    subscript(_ r: Int, _ c: Int) -> Item? {
        get {
            if !(c < width && r < height) {return nil}
            return data[r*width + c]
        }
        set {
            precondition(c < width && r < height, "Index out of range")
            if (c < width && r < height) {
                data[r*width + c] = newValue!
            }
        }
    }
    
    func isValid(i: Int,j: Int) -> Bool {
        return (0 <= i) &&
        (0 <= j) &&
        (i < height) &&
        (j < width)
    }

}

extension contraption<GridItem> {
    mutating func trace(p: Photon) -> [Photon] {
        let r = p.i
        let c = p.j
        self.lit[r*width + c] += 1
        let newDirections = self[r,c]!.cast(dir: p.dir)
        var newPhotons: [Photon] = []
        for d in newDirections {
            let (nr,nc) = (r,c)+d
            if self.isValid(i: nr, j: nc) {
                newPhotons.append(Photon(i: nr, j: nc, dir: d))
            }
        }
        return newPhotons
    }
}



struct Day16 {
    let filename = "/Users/mehrdad/workspace/swift_projects/AoC23/Day16/input.txt"
    let lines: [String.SubSequence]
    
    init() {
        let contents = readfile(filename)
        lines = contents.split(omittingEmptySubsequences: true) { $0.isNewline }
    }
    
    init(input: String) {
        let contents = input
        lines = contents.split(omittingEmptySubsequences: true) { $0.isNewline }
    }
    
    func readContraption() -> contraption<GridItem> {
        let chmap: [Character:GridItem] = [".":.dot,
                                           "/":.foreslash,
                                           "\\":.backslash,
                                           "|": .vert,
                                           "-":.dash]
        let w = lines[0].count
        let h = lines.count
        var m = contraption(h,w, zero: GridItem.dot, separtor: " ")
        for i in lines.indices {
            for (j,ch) in lines[i].enumerated()  where ch != "." {
                m[i,j] = chmap[ch]!
            }
        }
        return m
    }
    
    func partTwo() -> Int {
        var surroundings: Set<Photon> = []
        for j in 0..<lines[0].count {
            surroundings.insert(Photon(i: 0,j: j,dir: .down))
            surroundings.insert(Photon(i: lines.count - 1,j: j,dir: .up))
        }
        for i in 0..<lines.count {
            surroundings.insert(Photon(i: i,j: 0,dir: .right))
            surroundings.insert(Photon(i: i,j: lines[0].count - 1,dir: .left))
        }
        func dfsloop(_ e: Photon) -> Int {
            var contrap: contraption<GridItem> = readContraption()
            var seen: Set<Photon> = []
            var stack = [e]
            while !stack.isEmpty {
                let curPhoton = stack.popLast()!
                seen.insert(curPhoton)
                let validPhotons = contrap.trace(p: curPhoton)
                for p in validPhotons where !seen.contains(p) {
                    stack.append(p)
                }
            }
            surroundings.subtract(seen)
            return contrap.lit.filter {$0 > 0}.count
        }
        var curMax = 0
        while !surroundings.isEmpty {
            let emitter = surroundings.popFirst()!
            curMax = max(curMax, dfsloop(emitter))
        }
        return curMax
    }
    
    func partOne() -> Int {
        var contrap: contraption<GridItem> = readContraption()
        var seen: Set<Photon> = []
        var stack = [Photon(i: 0, j: 0, dir: .right)]
        while !stack.isEmpty {
            let curPhoton = stack.popLast()!
            seen.insert(curPhoton)
            let validPhotons = contrap.trace(p: curPhoton)
            for p in validPhotons where !seen.contains(p) {
                stack.append(p)
            }
        }
        return contrap.lit.filter {$0 > 0}.count
    }
    
    func sol() {
        print(partTwo())
    }
}
