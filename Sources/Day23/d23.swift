import Foundation
import Collections

struct Day23 {
    let filename = "/Users/mehrdad/workspace/swift_projects/AoC23/Day23/input.txt"
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
//        let x = Matrix<MapItems>.from(lines: lines, zero: MapItems.path )
//        print(x[0,0]!, x[1,1]!)
        trackBack()
//        var totalSteps: [Int] = []
//        var q: Deque<(Int, Int, Int)> = [] // step, r, c
//        var visited: Set<Pair> = []
//        q.append((0, 0, 1))
//        while !q.isEmpty {
//            let (s,r,c) = q.popFirst()!
//            if r == (x.height-1) && c == (x.width-2) {
//                totalSteps.append(s)
//                continue
//            }
//            visited.insert(Pair(r, c))
//            for (d, nr,nc) in ngbrs(r,c, x.height, x.width) {
//                if x[nr,nc] == .forest ||
//                    visited.contains(Pair(nr, nc)) ||
//                    (x[nr,nc] != .path && x[nr,nc] != d ) { continue }
//                q.append((s+1, Int(nr), Int(nc)))
//
//            }
//        }
//        print(totalSteps)
//        return 1
    }
    
    func trackBack() -> Int {
        let x = Matrix<MapItems>.from(lines: lines, zero: MapItems.path )
        var totalSteps: [Int] = []
//        var q: [(Int, Int, Int)] = [] // step, r, c
        var visited: Set<Pair> = []
//        q.append((0, 0, 1))
        func dfs(_ s: Int, _ r: Int , _ c: Int) {
            if r == (x.height-1) && c == (x.width-2) {
                totalSteps.append(s)
                return
            }
            
            for (d, nr,nc) in ngbrs(r,c, x.height, x.width) {
                if x[nr,nc] == .forest ||
                    visited.contains(Pair(nr, nc)) ||
                    (x[nr,nc] != .path && x[nr,nc] != d ) { continue }
                visited.insert(Pair(nr,nc))
                dfs(s+1, Int(nr), Int(nc))
                visited.remove(Pair(nr,nc))
            }
        }
        
        dfs(0, 0, 1)
        
        return (totalSteps.max()!)
    }
    
    func partTwo() -> Int {
        trackBack2()
    }
    
    func trackBack2() -> Int {
        // First, Path compression to build a graph.
        // Then dfs on graph to find the longest path.
        let x = Matrix<MapItems>.from(lines: lines, zero: MapItems.path )
        var graph: [Pair: [(Pair, Int)]] = [:]
        
        let start = Pair(0,1)
        var parent: [Pair:Pair] = [:]
        parent[start] = start
        var stack: [(Pair,Pair, Int)] = [] //  [(start, start, 0)] // parent, current, step
        ngbrSet(start, x).forEach {stack.append((start, $0, 1))}
        while !stack.isEmpty {
            let (p,c,step) = stack.popLast()!
            if let x = parent[c] {
                if let adjList = graph[x] {
                    if adjList.contains(where: { (cp, ss) in
                        cp == parent[p]!
                    }) { continue }
                }
                graph[parent[p]!, default: []].append((x, step))
                graph[x, default: []].append((parent[p]!, step))
            } else {
                let adjacents = ngbrSet(c, x).subtracting([p])
                if adjacents.count == 1 {
                    parent[c] = parent[p]
                    adjacents.forEach {stack.append((c, $0, step+1))}
                } else if adjacents.count == 0 {
                    parent[c] = c
                    graph[parent[p]!, default: []].append((c, step))
                    graph[parent[c]!, default: []].append((parent[p]!, step))
                } else { // more ngbrs => it's a junction
                    parent[c] = c
                    graph[parent[p]!, default: []].append((parent[c]!, step))
                    graph[parent[c]!, default: []].append((parent[p]!, step))
                    adjacents.forEach {stack.append((c, $0, 1))}
                }
            }
            
        }
//        print(x.width, x.height)
//        graph.forEach { (key: Pair, value: [(Pair, Int)]) in
//            print(key, value)
//        }
        let end = Pair(x.height-1, x.width - 2)
        func dfs(_ st: Pair, _ steps: Int, _ seenPoints: Set<Pair>) -> Int {
            if st == end { return steps }
            
            var maxTot = 0
            for (np, ns) in graph[st]!.filter({ (adjP, dis) in
                !seenPoints.contains(adjP)
            }) {
                maxTot = max(maxTot,  dfs(np, ns + steps, seenPoints.union([st])))
            }
            return maxTot
        }

        return dfs(start, 0, [start])
    }
    
    func ngbrSet(_ cur: Pair, _ m: Matrix<MapItems>) -> Set<Pair> {
        let r = cur.r
        let c = cur.c
        var res: Set<Pair> = []
        let lst: [(MapItems, Int, Int)] = [(.left, 0, -1), (.right, 0, 1), (.up, -1, 0), (.down, 1, 0)]
        for (_, dr, dc) in lst {
            let nr = r+dr
            let nc = c+dc
            if nr < 0 || nr >= m.height || nc < 0 || nc >= m.width { continue }
            if m[UInt(nr),UInt(nc)] == .forest { continue }
            res.insert(Pair(nr, nc))
        }
        return res
    }
    
    func ngbrs(_ r: Int, _ c: Int, _ h: UInt, _ w: UInt) -> [(MapItems, UInt, UInt)] {
        var res: [(MapItems, UInt, UInt)] = []
        let lst: [(MapItems, Int, Int)] = [(.left, 0, -1), (.right, 0, 1), (.up, -1, 0), (.down, 1, 0)]
        for (d, dr, dc) in lst {
            let nr = r+dr
            let nc = c+dc
            if nr < 0 || nr >= h || nc < 0 || nc >= w { continue }
            res.append((d, UInt(nr), UInt(nc)))
        }
        return res
    }
    
    struct Pair: Hashable, CustomStringConvertible {
        let r: Int
        let c: Int
        var description: String {
            "(\(r), \(c))"
        }
        
        init(_ r: Int, _ c: Int) {
            self.r = r
            self.c = c
        }
        
        init(_ r: UInt, _ c: UInt) {
            self.r = Int(r)
            self.c = Int(c)
        }
    }
    
    enum MapItems: Character, LosslessStringConvertible {
        case left = "<"
        case right = ">"
        case up = "^"
        case down = "v"
        case forest = "#"
        case path = "."
        
        init?(_ description: String) {
            self.init(rawValue: Character(description))
        }
        
        var description: String {
            String(self.rawValue)
        }
    }
    
    struct Matrix<Item: LosslessStringConvertible> : CustomStringConvertible {
        let height: UInt
        let width: UInt
        let zero: Item
        let separator: String
        var data: [Item]
        
        static func from(lines: [String.SubSequence], zero: Item) -> Matrix<Item> {
            let w = UInt(lines[0].count)
            let h = UInt(lines.count)
            var m = Matrix(h, w, zero: zero, separtor: "")
            for i in lines.indices {
                for (j,ch) in lines[i].enumerated() {
                    let num = Item(String(ch))
                    m[UInt(i),UInt(j)] = num
                }
            }
            return m
        }
        
        
        init(_ height: UInt,_ width: UInt, zero: Item, separtor: String=",") {
            self.height = height
            self.width = width
            self.zero = zero
            self.separator = separtor
            self.data = [Item](repeating: zero, count: Int(width * height))
        }
        
        func _isValid(_ i: Int,_ j: Int) -> Bool {
            return 0 <= i && i < height && 0 <= j && j < width
        }
        
        func _isValid(_ i: UInt,_ j: UInt) -> Bool {
            return i < height && j < width
        }
        
        func validate(_ i: Int,_ j: Int) -> (UInt, UInt)? {
            _isValid(i, j) ? (UInt(i), UInt(j)) : nil
        }
        
        var description: String {
            var line: [String] = []
            for i in 0..<height {
                let row = (0..<width).map { "\(self[i, $0]!)" }
                    .joined(separator: separator)
                line.append(row)
            }
            return line.joined(separator: "\n")
        }
        subscript(_ r: UInt, _ c: UInt) -> Item? {
            get {
                if !_isValid(r, c) {return nil}
                return data[Int(r*(width) + c)]
            }
            set {
                precondition(_isValid(r, c), "Index out of range")
                data[Int(r*(width) + c)] = newValue!
            }
        }
    }
}
