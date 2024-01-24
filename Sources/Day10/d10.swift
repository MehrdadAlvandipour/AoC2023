//
//  d10.swift
//  AoC23
//
//  Created by Mehrdad Alvandipour on 12/31/23.
//

import Foundation
import Collections


struct Day10{
    let filename = "/Users/mehrdad/workspace/swift_projects/AoC23/Day10/input.txt"
    let lines: [String.SubSequence]
    var boundary: Set<Location> = []
    
    
    init() {
        let contents = readfile(filename)
        lines = (contents).split(separator:"\n")
    }
    
    init(input: String) {
        let contents = input
        lines = (contents).split(separator:"\n")
    }
    
    func partOne() -> Int{
        var pm = PipeMaze(lines: lines)
        return pm.partOne()
    }
    
    func partTwo() -> Int{
        var pm = PipeMaze(lines: lines)
        return pm.partTwo()
    }
    
    // MARK: Data structures for the problem start here.
    struct Location: Hashable {
        let r: Int
        let c: Int
        var distance: Int = 0
        
        // RayCasting
        func isIn(polygon vertices: [Location]) -> Bool {
            let numOfVertices = vertices.count
            var inside = false
            var p1 = vertices[0]
            for i in 0...numOfVertices {
                let p2 = vertices[i%numOfVertices]
                if r > min(p1.r, p2.r) && r <= max(p1.r, p2.r) {
                    if c <= max(p1.c, p2.c) {
                        let xIntersection: Double = Double((r-p1.r)*(p2.c - p1.c))/Double(p2.r - p1.r) + Double(p1.c)
                        if p1.c == p2.c || Double(c) <= xIntersection {
                            inside.toggle()
                        }
                    }
                }
                p1 = p2
            }
            
            return inside
        }
        
        // visited set should only care about r and c.
        static func ==(lhs: Location, rhs: Location) -> Bool {
            return lhs.r == rhs.r && lhs.c == rhs.c
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(r)
            hasher.combine(c)
        }
        
        //    static func +(lhs: Location, rhs: Location) -> Location {
        //        return Location(r: lhs.r + rhs.r, c: lhs.c + rhs.c)
        //    }
        //    static func +(lhs: Location, rhs: (Int,Int)) -> Location {
        //        return Location(r: lhs.r + rhs.0, c: lhs.c + rhs.1)
        //    }
        static func +(lhs: Location, rhs: Direction) -> Location {
            switch rhs {
            case .Left:
                return Location(r: lhs.r, c: lhs.c - 1, distance: lhs.distance + 1)
            case .Right:
                return Location(r: lhs.r, c: lhs.c + 1, distance: lhs.distance + 1)
            case .Up:
                return Location(r: lhs.r - 1, c: lhs.c, distance: lhs.distance + 1)
            case .Down:
                return Location(r: lhs.r + 1, c: lhs.c, distance: lhs.distance + 1)
            }
            
        }
    }

    enum Direction {
        case Left
        case Right
        case Up
        case Down
    }
    
    struct PipeMaze {
        let lines: [String.SubSequence]
        var boundary: Set<Location> = []
        
        init(lines: [String.SubSequence]) {
            self.lines = lines
        }
        
        func showWindow(at loc: Location) {
            let r = loc.r
            let c = loc.c
            for dr in [-1,0,1] {
                var row: [Character] = []
                for dc in [-1,0,1] {
                    if r+dr < 0 ||
                        r+dr >= lines.count ||
                        c+dc < 0 ||
                        c+dc >= lines[0].count {
                        continue
                    }
                    row.append(String(lines[r+dr]).at(c+dc)!)
                }
//                print(row)
            }
        }
        
        func findS() -> Location? {
            for (r, line) in lines.enumerated() {
                for (c, ch) in line.enumerated() {
                    if ch == "S" {
                        return Location(r: r, c: c)
                    }
                }
            }
            return nil
        }
        
        func readSymbol(at loc: Location) -> Character? {
            if loc.r < 0 || loc.r >= lines.count ||
                loc.c < 0 || loc.c >= lines[0].count {
                return nil
            }
            return String(lines[loc.r]).at(loc.c)!
        }
        
        mutating func bfs(at loc: Location, with type: Character) -> Int {
            var q: Deque<Location> = []
            q.append(loc)
            var dist = 0
            while !q.isEmpty {
                let currentLocation = q.popFirst()!
                boundary.insert(currentLocation)
                dist = max(dist, currentLocation.distance)

                var symbol = readSymbol(at: currentLocation)
                symbol = symbol == "S" ? type : symbol
                switch symbol {
                case "|":
                    if !boundary.contains(currentLocation + .Up ) {q.append( currentLocation + .Up )}
                    if !boundary.contains(currentLocation + .Down ) {q.append( currentLocation + .Down )}
                case "-":
                    if !boundary.contains(currentLocation + .Right ) {q.append( currentLocation + .Right )}
                    if !boundary.contains(currentLocation + .Left ) {q.append( currentLocation + .Left )}
                case "L":
                    if !boundary.contains(currentLocation + .Right ) {q.append( currentLocation + .Right )}
                    if !boundary.contains(currentLocation + .Up ) {q.append( currentLocation + .Up )}
                case "J":
                    if !boundary.contains(currentLocation + .Left ) {q.append( currentLocation + .Left )}
                    if !boundary.contains(currentLocation + .Up ) {q.append( currentLocation + .Up )}
                case "7":
                    if !boundary.contains(currentLocation + .Left ) {q.append( currentLocation + .Left )}
                    if !boundary.contains(currentLocation + .Down ) {q.append( currentLocation + .Down )}
                case "F":
                    if !boundary.contains(currentLocation + .Right ) {q.append( currentLocation + .Right )}
                    if !boundary.contains(currentLocation + .Down ) {q.append( currentLocation + .Down )}
                default:
                    ()
                }
            }
            return dist
        }
        
        mutating func partOne() -> Int {
            let sPosition = findS()!
            showWindow(at: sPosition)
            return bfs(at: sPosition, with: findStartType(startLocation: sPosition))
        }
        
        func leftToRight() -> Set<Location> {
            var inside: Set<Location> = []
            for r in 0..<lines.count {
                var flag: Bool = false
                for c in 0..<lines[0].count {
                    let p = Location(r: r, c: c)
                    if flag &&
                        !boundary.contains(p){
                        inside.insert(p)
                    }
                    if boundary.contains(p) {
                        if readSymbol(at: p) != "-" {
                            flag.toggle()
                        } else {
                            break
                        }
                    }
                }
            }
            return inside
        }
        
        func rightToLeft() -> Set<Location> {
            var inside: Set<Location> = []
            for r in (0..<lines.count) {
                var flag: Bool = false
                for c in (0..<lines[0].count).reversed() {
                    let p = Location(r: r, c: c)
                    if flag &&
                        !boundary.contains(p){
                        inside.insert(p)
                    }
                    if boundary.contains(p) {
                        if readSymbol(at: p) == "|" {
                            flag.toggle()
                        } else {
                            break
                        }
                    }
                }
            }
            return inside
        }
        
        func topToBottom() -> Set<Location> {
            var inside: Set<Location> = []
            for c in 0..<lines[0].count  {
                var flag: Bool = false
                for r in (0..<lines.count) {
                    let p = Location(r: r, c: c)
                    if flag &&
                        !boundary.contains(p){
                        inside.insert(p)
                    }
                    if boundary.contains(p) {
                        if readSymbol(at: p) == "-" {
                            flag.toggle()
                        } else {
                            break
                        }
                    }
                }
            }
            return inside
        }
        
        func bottomToTop() -> Set<Location> {
            var inside: Set<Location> = []
            for c in 0..<lines[0].count  {
                var flag: Bool = false
                for r in (0..<lines.count).reversed() {
                    let p = Location(r: r, c: c)
                    if flag &&
                        !boundary.contains(p){
                        inside.insert(p)
                    }
                    if boundary.contains(p) {
                        if readSymbol(at: p) == "-" {
                            flag.toggle()
                        } else {
                            break
                        }
                    }
                }
            }
            return inside
        }
        
        func drawPipes() {
            var pipeDiagram = [[String]](repeating: [String](repeating: "0", count: lines[0].count), count: lines.count)
            for r in 0..<lines.count {
                for c in 0..<lines[0].count {
                    let p = Location(r: r, c: c)
                    if boundary.contains(p) {
                        pipeDiagram[r][c] = String(readSymbol(at: p)!)
                    } else {
                        pipeDiagram[r][c] = "."
                    }
                }
//                print(pipeDiagram[r].reduce("", +))
            }
            
        }
        
        func dfsFindVertices(from loc: Location, with type: Character) -> [Location] {
            var visited: Set<Location> = []
            var vertices: [Location] = []
            var stack: Deque<Location> = []
            stack.append(loc)

            while !stack.isEmpty {
                let currentLocation = stack.popLast()!
                visited.insert(currentLocation)

                var symbol = readSymbol(at: currentLocation)
                symbol = symbol == "S" ? type : symbol
                if symbol != "|" && symbol != "-" {
                    vertices.append(currentLocation)
                }
                switch symbol {
                case "|":
                    if !visited.contains(currentLocation + .Up) { stack.append(currentLocation + .Up) }
                    if !visited.contains(currentLocation + .Down) { stack.append(currentLocation + .Down) }
                case "-":
                    if !visited.contains(currentLocation + .Right) { stack.append(currentLocation + .Right) }
                    if !visited.contains(currentLocation + .Left) { stack.append(currentLocation + .Left) }
                case "L":
                    if !visited.contains(currentLocation + .Right) { stack.append(currentLocation + .Right) }
                    if !visited.contains(currentLocation + .Up) { stack.append(currentLocation + .Up) }
                case "J":
                    if !visited.contains(currentLocation + .Left) { stack.append(currentLocation + .Left) }
                    if !visited.contains(currentLocation + .Up) { stack.append(currentLocation + .Up) }
                case "7":
                    if !visited.contains(currentLocation + .Left) { stack.append(currentLocation + .Left) }
                    if !visited.contains(currentLocation + .Down) { stack.append(currentLocation + .Down) }
                case "F":
                    if !visited.contains(currentLocation + .Right) { stack.append(currentLocation + .Right ) }
                    if !visited.contains(currentLocation + .Down) { stack.append(currentLocation + .Down) }
                default:
                    ()
                }
            }
            return vertices
        }
        
        func findStartType(startLocation s: Location) -> Character {
            let possiblePipes: [Direction:Set<Character>] = [
                .Up: ["|", "F", "7"],
                .Down: ["|", "J", "L"],
                .Right: ["-", "7", "J"],
                .Left: ["-", "F", "L"]
            ]
            var connections: Set<Direction> = []
            for d: Direction in [.Up, .Down, .Right, .Left] {
                if possiblePipes[d]!.contains(readSymbol(at: s+d) ?? Character(" ")) {
                    connections.insert(d)
                }
            }
            switch connections {
            case Set([Direction.Right, Direction.Left]):
                return "-"
            case Set([Direction.Right, Direction.Up]):
                return "L"
            case Set([Direction.Right, Direction.Down]):
                return "F"
            case Set([Direction.Down, Direction.Left]):
                return "7"
            case Set([Direction.Up, Direction.Down]):
                return "|"
            case Set([Direction.Up, Direction.Left]):
                return "J"
            default:
                return "?"
            }
        }
        
        func rayCastAllPoints(through sortedVertices: [Location]) -> Int {
            var total = 0
            for r in 0..<lines.count {
                for c in 0..<lines[0].count {
                    let p = Location(r: r, c: c)
                    if !boundary.contains(p) && p.isIn(polygon: sortedVertices){
                        total += 1
                    }
                }
            }
            return total
        }
        
        mutating func partTwo() -> Int {
            let sPosition = findS()!
            showWindow(at: sPosition)
            let startType = findStartType(startLocation: sPosition)
            _ = bfs(at: sPosition, with: startType)
//            print("paths length \(boundary.count)")
            
            let sortedVertices = dfsFindVertices(from: sPosition,
                                                 with: startType)
//            print("numOfVertices: \(sortedVertices.count)")
            return rayCastAllPoints(through: sortedVertices)
        }
    }
    
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
