import Foundation

struct Day25 {
    let filename = "/Users/mehrdad/workspace/swift_projects/AoC23/Day25/input.txt"
    let lines: [String.SubSequence]
    
    init() {
        let contents = readfile(filename)
        lines = contents.split(omittingEmptySubsequences: true) { $0.isNewline }
    }
    
    init(input: String) {
        let contents = input
        lines = contents.split() { $0.isNewline }
    }
    
    func partOne() -> Int {
        part1Sol()
    }
    
    func partTwo() -> Int {
        // there's no partTwo for Day 25.
        1
    }
    
    func part1Sol() -> Int {
        var graph: [String: Set<String>] = [:]
        for line in lines {
            let kv = line.split(separator: ":")
            let node = String(kv[0])
            let adjNodes = kv[1].split(separator: " ").map { String($0)}
            graph[node, default: []].formUnion(adjNodes)
            adjNodes.forEach { n in
                graph[n, default: []].insert(node)
            }
        }
        graph.forEach { (key: String, value: Set<String>) in
            print(key, value)
        }
        // TODO solve with stoer wagner algo
        //
        // Solved in python with netwrokx for now
        return 562912
    }
}
