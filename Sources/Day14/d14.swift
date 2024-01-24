//
//  d14.swift
//  AoC23
//
//  Created by Mehrdad Alvandipour on 1/5/24.
//

import Foundation

struct Table<Item: Hashable> : CustomStringConvertible, Hashable {
    
    let height: Int
    let width: Int
    let zero: Item
    let separator: String
    var data: [Item]
    
    var description: String {
        var line: [String] = []
        for i in 0..<height {
            let row = (0..<width).map { "\(self[i, $0]!)" }
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
    
    static func ==(lhs: Self, rhs: Self) -> Bool{
        if lhs.data.count != rhs.data.count { return false}
        for i in lhs.data.indices {
            if lhs.data[i] != rhs.data[i] {
                return false
            }
        }
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(data)
    }
    
}

protocol Tiltable {
    mutating func tiltNorthSouth(strideStep: Int)
    mutating func tiltWestEast(strideStep: Int)
    mutating func cycle()
    func loadOnNorth() -> Int
}

extension Table<CellStates> : Tiltable {
    mutating func tiltNorthSouth(strideStep: Int) {
        let height = self.height
        let first = strideStep > 0 ? 0 : (height-1)
        let last = strideStep > 0 ? height : -1
        for j in 0..<self.width {
            var availablePosition = first
            for i in stride(from: first, to: last, by: strideStep) {
                let ch = self[i,j]
                if ch == .Dot {
                    continue
                }
                if ch == .O {
                    self[i,j] = .Dot
                    self[availablePosition,j] = .O
                    availablePosition += strideStep
                }
                if ch == .Sharp {
                    self[i,j] = .Sharp
                    availablePosition = i + strideStep
                }
            }
        }
    }

    mutating func tiltWestEast(strideStep: Int) {
        let width = self.width
        let first = strideStep > 0 ? 0 : (width-1)
        let last = strideStep > 0 ? width : -1
        for i in 0..<self.height {
            var availablePosition = first
            for j in stride(from: first, to: last, by: strideStep) {
                let ch = self[i,j]
                if ch == .Dot {
                    continue
                }
                if ch == .O {
                    self[i,j] = .Dot
                    self[i,availablePosition] = .O
                    availablePosition += strideStep
                }
                if ch == .Sharp {
                    self[i,j] = .Sharp
                    availablePosition = j + strideStep
                }
            }
        }
    }

    mutating func cycle() {
        self.tiltNorthSouth(strideStep: 1)
        self.tiltWestEast(strideStep: 1)
        self.tiltNorthSouth(strideStep: -1)
        self.tiltWestEast(strideStep: -1)
    }

    func loadOnNorth() -> Int {
        let m = self
        var res = 0
        let height = m.height
        for i in 0..<height {
            for j in 0..<m.width {
                if m[i,j] == .O {
                    res += height - i
                }
            }
        }
        return res
    }
}

enum CellStates {
    case O
    case Sharp
    case Dot
}


func readfile(_ filename: String) -> String {
    var contents : String
    contents = (try? String(contentsOfFile: filename)) ?? ""
    if contents == "" {
        print("failed to read file")
    }
    return contents
}

struct Day14 {
    let filename = "/Users/mehrdad/workspace/swift_projects/AoC23/Day14/input.txt"
    let lines: [String.SubSequence]
    
    init() {
        let contents = readfile(filename)
        lines = contents.split(omittingEmptySubsequences: true) { $0.isNewline }
    }
    
    init(input: String) {
        let contents = input
        lines = contents.split(omittingEmptySubsequences: true) { $0.isNewline }
    }
    
    func partOne() -> Int {
        var m = readTable()
        m.tiltNorthSouth(strideStep: 1)
        return m.loadOnNorth()
    }
    
    func partTwo() -> Int {
        let m = readTable()
        let (groupElementsOrders,groupOrder,initSteps) = findOrders(m)
        var ans = 1000000000 - initSteps
        ans = ans % groupOrder
        return groupElementsOrders.filter { $0.value == ans}.keys.map {$0.loadOnNorth()}[0]
    }
    
    func readTable() -> some Tiltable & Hashable {
        let chmap: [Character:CellStates] = ["O":.O, "#":.Sharp, ".":.Dot]
        let w = lines[0].count
        let h = lines.count
        var m = Table(h,w, zero: CellStates.Dot, separtor: " ")
        for i in lines.indices {
            for (j,ch) in lines[i].enumerated() {
                m[i,j] = chmap[ch]!
            }
        }
        return m
    }
    
    func findOrders<T: Tiltable & Hashable>(_ m: T) ->([T: Int],
                                              groupOrder: Int,
                                              initialSteps: Int)  {
        var m = m
        var memberOrders: [T: Int] = [:]
        memberOrders[m] = 0
        var i = 0
        repeat {
            m.cycle()
            i += 1
            if let initialSteps = memberOrders[m] {
                let groupOrder = i - initialSteps
                memberOrders = memberOrders.filter { $0.value >= initialSteps }
                    .mapValues { $0 - initialSteps }
                return (memberOrders, groupOrder, initialSteps)
            }
            memberOrders[m] = i
        } while i < 10000
        return (memberOrders, i, -1)
    }
}
