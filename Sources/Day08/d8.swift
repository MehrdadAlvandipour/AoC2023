//
//  d8.swift
//  AoC23
//
//  Created by Mehrdad Alvandipour on 12/31/23.
//

import Foundation


struct Day8 {
    let filename = "/Users/mehrdad/workspace/swift_projects/AoC23/Day8/input.txt"
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
    
    func getAdjDict() -> [String:Node] {
        var adjDict: [String:Node] = [:]
        for line in lines[1...] {
            let nodeInfo = line.split(separator: "=")
            let nodeId = String(nodeInfo[0]).trimmingCharacters(in: .whitespaces)
            let LR = nodeInfo[1].split(separator: ",")
                .map { s in
                    s.trimmingCharacters(in: CharacterSet(charactersIn: " ()"))
                }
            adjDict[nodeId] = Node(left: LR[0], right: LR[1])
        }
        return adjDict
    }
    
    func partOne() -> Int {
        let w = Wasteland(lines: lines, adjDict: getAdjDict())
        return w.partOne()
    }
    
    func partTwo() -> Int {
        let w = Wasteland(lines: lines, adjDict: getAdjDict())
        return w.partTwo()
    }
    
    struct Node {
        let left: String
        let right: String
    }
    
    struct Wasteland {
        let instructions: String
        let lines: [String.SubSequence]
        var adjDict: [String:Node] = [:]
        
        init(lines: [String.SubSequence], adjDict: [String : Node]) {
            self.instructions =  String(lines[0])
            self.lines = lines
            self.adjDict = adjDict
        }
        
        func takeOneStep(nodeID: String, direction: Character) -> String {
            if direction == "L" {
                return adjDict[nodeID]!.left
            } else {
                return adjDict[nodeID]!.right
            }
        }
        
        func follow(from curNodeId: String, until reached: (String) -> Bool ) -> Int {
            var i = 0
            var step = 0
            var curNodeId = curNodeId
            repeat {
                curNodeId = takeOneStep(nodeID: curNodeId, direction: instructions.at(i)!)
                step += 1
                i = (i+1) % instructions.count
            }  while !reached(curNodeId)
            return step
        }
        
        func partOne() -> Int {
            return follow(from: "AAA") {$0 == "ZZZ"}
        }
        
        func nodesEnding(with c: String) -> [String] {
            return adjDict.keys.filter { s in
                s.hasSuffix(c)
            }
        }
        
        func partTwo() -> Int {
            let paths = nodesEnding(with: "A")
            let res = paths.map { p in
                follow(from: p) { $0.hasSuffix("Z")}
            }
            return res.reduce(1) { partialResult, x in lcm(partialResult, x) }
        }
    }
}


/*
 Returns the Greatest Common Divisor of two numbers.
 */
func gcd(_ x: Int, _ y: Int) -> Int {
    var a = 0
    var b = max(x, y)
    var r = min(x, y)
    
    while r != 0 {
        a = b
        b = r
        r = a % b
    }
    return b
}

/*
 Returns the least common multiple of two numbers.
 */
func lcm(_ x: Int, _ y: Int) -> Int {
    return x / gcd(x, y) * y
}

private extension String {
    func getFirstIndex(of: Character) -> Int? {
        return self.firstIndex(of: of)?.utf16Offset(in: self)
    }
    
    func at(_ idx: Int) -> Character? {
        if idx >= self.count || idx < 0 {
            return nil
        }
        return self[String.Index(utf16Offset: idx, in: self)]
    }
}
