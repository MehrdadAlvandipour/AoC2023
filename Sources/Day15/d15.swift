//
//  d15.swift
//  AoC23
//
//  Created by Mehrdad Alvandipour on 1/6/24.
//

import Foundation

enum Action {
    case set
    case rem
}

struct Lens : Hashable, CustomStringConvertible {
    let type: String
    let focal: Int
    let action: Action
    var description: String {
        return "\(type) \(focal) \(action)"
    }
    
    init(type: String, focal: Int, action: Action) {
        self.type  = type
        self.focal = focal
        self.action = action
    }
    
    init(_ s: some StringProtocol) {
        if s.contains("-") {
            let tf = s.prefix(s.count - 1)
            self.init(type: String(tf), focal: -1 , action: .rem)
        } else if s.contains("=") {
            let tf = s.split(separator: "=")
            self.init(type: String(tf[0]), focal: Int(tf[1])!, action: .set)
        } else {
            fatalError("unknow lens")
        }
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.type == rhs.type
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
    }
}

//func readfile(_ filename: String) -> String {
//    var contents : String
//    contents = (try? String(contentsOfFile: filename)) ?? ""
//    if contents == "" {
//        print("failed to read file")
//    }
//    return contents
//}

struct Day15 {
    let filename = "/Users/mehrdad/workspace/swift_projects/AoC23/Day15/input.txt"
    let lines: [String.SubSequence]
    
    init() {
        let contents = readfile(filename)
        lines = contents.split(omittingEmptySubsequences: true) { $0.isNewline }
    }
    
    init(input: String) {
        let contents = input
        lines = contents.split(omittingEmptySubsequences: true) { $0.isNewline }
    }
    
    func hashAlgo(_ x: some StringProtocol) -> Int {
        let asciiVals = Array(x).map {$0.asciiValue! }
        var res = 0
        for v in asciiVals {
            res += Int(v)
            res = (res*17) % 256
        }
        return res
    }
    
    func partOne() -> Int {
        let x = lines[0].split(separator: ",")
        let ans = x.map { hashAlgo($0)}
            .reduce(0, +)
        return (ans )
    }
    
    func computeBoxPower(arr: [Lens]) -> Int {
        return arr.enumerated()
            .map { ($0.offset + 1) * $0.element.focal }
            .reduce(0, +)
    }
    
    func computePower(b: [[Lens]]) -> Int {
        return b.enumerated()
            .map { ($0.offset + 1) * computeBoxPower(arr: $0.element)}
            .reduce(0, +)
    }
    
    func partTwo() -> Int{
        var boxes = [[Lens]](repeating: [], count: 256)
        let x = lines[0].split(separator: ",")
        for l in x {
            let item = Lens(l)
            switch item.action {
            case .rem:
                if let i = boxes[hashAlgo(item.type)].firstIndex(of: item) {
                    boxes[hashAlgo(item.type)].remove(at: i)
                }
            case .set:
                if let i = boxes[hashAlgo(item.type)].firstIndex(of: item) {
                    boxes[hashAlgo(item.type)][i] = item
                } else {
                    boxes[hashAlgo(item.type)].append(item)
                }
            }
        }
        return (computePower(b: boxes))
    }
}
