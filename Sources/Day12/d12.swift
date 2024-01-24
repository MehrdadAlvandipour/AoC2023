//
//  d12.swift
//  AoC23
//
//  Created by Mehrdad Alvandipour on 1/1/24.
//

import Foundation


struct Day12 {
    let filename = "/Users/mehrdad/workspace/swift_projects/AoC23/Day12/input.txt"
    var lines: [String.SubSequence] = []
    var memo: [Row:Int] = [:]
        
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
        var hp = HotSprings(lines: lines)
        return hp.partOne()
    }
    
    func partTwo() -> Int {
        var hp = HotSprings(lines: lines)
        return hp.partTwo()
    }
    
    struct Row : Hashable {
        let record: [Character]
        let list: [Int]
        
        init(_ line: some StringProtocol, unfold: Bool = false) {
            let parts = line.split(separator: " ")
            if unfold {
                let s = [String](repeating: String(parts[0]), count: 5).joined(separator: "?")
                let l = [String](repeating: String(parts[1]), count: 5).joined(separator: ",")
                self.init(s,l)
            } else {
                self.init(parts[0], parts[1])
            }

        }
        
        init(_ record: [Character], _ list: [Int]) {
            self.record = record
            self.list = list
        }
        
        init(_ s: some StringProtocol, _ l: some StringProtocol) {
            self.record  = Row.cleanRecord(s)
            self.list = l.split(separator: ",").map(){Int($0)!}
        }
        
        static func cleanRecord(_ s: some StringProtocol) -> [Character] {
            let s = s.trimmingCharacters(in: ["."])
            var rec: [Character] = []
            for ch in s {
                if ch == "." {
                    if let lastCh = rec.last {
                        if lastCh == ch {
                            continue
                        }
                    }
                }
                rec.append(ch)
            }
            return rec
        }
        
    }
    
    struct HotSprings {
        let lines: [String.SubSequence]
        var memo: [Row:Int] = [:]
        
        init(lines: [String.SubSequence]) {
            self.lines = lines
        }
        
        mutating func numAssignments(row: Row) -> Int{
            if let num = memo[row] {
                return num
            }
            let num = numAssignments_(row: row)!
            memo[row] = num
    //        memo[Row(row.record.reversed(), row.list.reversed())] = num
            return num
        }
        
        mutating func numAssignments_(row: Row) -> Int? {
            if row.record.isEmpty { return row.list.isEmpty ? 1 : 0 }
            if row.list.isEmpty { return row.record.contains("#") ? 0 : 1 }
            
            if Int(ceil(Double(row.record.count) / 2.0)) < row.list.count {
                return 0
            }
            
            // here we have non-trivial rows
            if row.record.last == "." {
                return numAssignments(row: Row(row.record.dropLast(1), row.list) )
            } else if row.record.last == "#" {
                let n = row.list.last!
                let recSuffix = row.record.suffix(n)
                if recSuffix.count != n || recSuffix.contains(".") {
                    return 0
                }
                
                let newRec = row.record.dropLast(n)
                if newRec.last == "#" {
                    return 0
                }
                return numAssignments(row: Row(Array(newRec.dropLast(1)), row.list.dropLast(1)))
            } else if row.record.last == "?" {
                let subRec: [Character] = row.record.dropLast(1)
                return numAssignments(row: Row(subRec, row.list)) +
                    numAssignments(row: Row(subRec + ["#"], row.list))
            } else {
                print("should not happen")
                return nil
            }
        }
        
        mutating func partOne() -> Int{
            lines.map { numAssignments(row: Row($0)) }
                .reduce(0, +)
        }
        
        mutating func partTwo() -> Int{
            lines.map { numAssignments(row: Row($0, unfold: true)) }
                .reduce(0, +)
        }
        
        mutating func sol() {
            print(partTwo())
        }
    }
    
}
