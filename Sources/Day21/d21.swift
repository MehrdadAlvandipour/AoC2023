import Foundation
import Collections

struct Day21 {
    let filename = "/Users/mehrdad/workspace/swift_projects/AoC23/Day21/input.txt"
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
        partOneSolved(64)
    }
    
    func basicInfo() {
        let m: Garden  = Garden.from(lines: lines, zero: "_")
        let sharpCells = m.data.lazy.filter { $0 == "#" }.count
        let totalCells = m.data.count
        let totalsCellsAgain = m.width * m.height
        print(sharpCells, totalCells, totalsCellsAgain, totalCells - sharpCells)
        // available cells are totalCells-sharpCells: 15454
        
        // with 130 steps we should reach the steady state of the map.
        // That is, all even/odd cells should have been visited once.
        // we can confirm that by checking 131, ...
        singleMap(130)
        singleMap(131)

        // Even 7734
        // Odd  7719
        // That's 15453
        // 1 point unreachable at id=3192 -> (24,48)
        //
    }
    
    func p(_ limit: Int) {
        let m: Garden  = Garden.from(lines: lines, zero: "_")
        let S = findS(m)
        var q: Deque<(UInt, Int, Int)> = [(0, Int(S.0), Int(S.1))]
        var visited: Set<Pair> = []
        var evens: Set<Pair> = []
        var odds: Set<Pair> = []
        while !q.isEmpty {
            let (step, r, c) = q.popFirst()!
            if step % 2 == 0 {
                evens.insert(Pair(r,c))
            } else {
                odds.insert(Pair(r,c))
            }
            if step == limit { continue }
            for (nr,nc) in news(r, c) {
                if m[UInt(mod(nr , 131)), UInt(mod(nc , 131))] == "#" ||
                    visited.contains(Pair(nr,nc)) {
                    continue
                }
                visited.insert(Pair(nr,nc))
                q.append((step+1, nr, nc))
            }
        }
        print(limit, evens.count, odds.count)
    }
    // p simulates the world for a given number of steps and return the number of
    // even and odd cells at the end. Of course if the given steps is odd, the final state
    // i.e. the answer is the number of odd cells and same for evens.
    // We can form the following table by evaluating p at 65 + x*131 steps.
    // 65 to reach the border of initial map, and x*131 to reach the the border of the x'th map
    // in each direction. That's the maximum exapnsion we need since the speed is constat at 1 cell/ step.
    // i.e. from each cell the information propagates to other cells right next to it (north,east,west,south).
    //
    // x is the radius of expanion in units of single maps/tiles.
    // e.g. x=2 means you need to simulate 2 tiles in each direction
    // The area of simulated universe is proportional to x^2. That's the total number of tiles we affect.
    // Each tile(map) is also a simple 131x131 chess board minus some "#" cells.
    // Black/white are the even/odd cells in our problem. The ratios of black/white/# cells are all constant.
    // We only get to see those as we expand. So the number of balck and white cells we _get to see_
    // should also grow proportional to the area, i.e. ~ x^2.
    //
    // P(steps) -> even odd
    // P(65) -> 3820 3917
    //
    // x    steps even odd
    // 0    65   3820 3917
    // 1    196  34920 34628
    // 2    327  96342 96829
    // 3    458  189644 188962
    // 4    589  312488 313365
    // 5    720  467992 466920
    // 6    851  652258 653525
    // 7    982  869964 868502
    // 8    1113 1115652 1117309
    // 9    1244 1395560 1393708
    // 10    1375 1702670 1704717
    // .
    // 202300 ?
    // 26501365 steps is 65 + (202300) * 131
    // i.e. we need 202300 expansion in each direction.
    // As we guessed above, ans is a quadratic polynomial of x (#expanded maps around initial map in each direction).
    // You can confirm that by looking at first-order and second-order differences of the following list,
    // which is taken from above table by alternating b/w odd and even columns to match with the parity of steps column.
    // f = [3917, 34920, 96829, 189644, 313365, 467992, 653525, 869964, 1117309, 1395560, 1704717]
    // After confirming that above (x,f) points are actually on a quadratic polynomial, then it's a matter of
    // solving a linear system to find the coefficients of the poly: a,b, and c.
    // c is f(0). For a and b we solve a simple 2x2 system on paper. The coeffs turn out to be
    // a=15453, b=15550, c = 3917
    // Answer to part two is just f(202300)
    
    func partTwo() -> Int {
        return f(202300)
    }
    
    func f(_ x: Int) -> Int {
        let a=15453
        let b=15550
        let c = 3917
        return a*(x*x) + b*x + c
    }
    
    struct Pair: Hashable {
        let r: Int
        let c: Int
        
        init(_ r: Int, _ c: Int) {
            self.r = r
            self.c = c
        }
    }
        
    func mod(_ a: Int, _ n: Int) -> Int {
        precondition(n > 0, "modulus must be positive")
        let r = a % n
        return r >= 0 ? r : r + n
    }

    func news(_ r: Int, _ c: Int) -> [(Int, Int)] {
        let newsDirections = [(-1,0),(0,1),(0,-1),(1,0)]
        return newsDirections.map { (rd, cd) in
            (rd+r,cd+c)
        }
    }
    
    func singleMap(_ limit: Int) {
        var m: Garden  = Garden.from(lines: lines, zero: "_")
        let S = findS(m)
        var q: Deque<(UInt, (UInt, UInt))> = [(0, S)]
        m[S.0, S.1] = "."
        while !q.isEmpty {
            let (step, cur) = q.popFirst()!
            if m[cur.0, cur.1] != "." { continue }
            m[cur.0, cur.1] = Character(String(step % 2))
            if step >= limit {
                continue
            }
            
            for (r,c) in m.ngbrCoordinate(cur.0, cur.1) {
                if m[r,c]! == "." { //
                    q.append((step+1, (r,c)))
                }
            }
        }
//        print(m)
        let even = (m.data.lazy.filter { $0 == "0" }.count)
        let odd = (m.data.lazy.filter { $0 == "1" }.count)
//        let unreachable = m.data.enumerated().filter { $0.1 != "0" && $0.1 != "1" && $0.1 != "#" }
//        print(unreachable)
        print(even,odd)
    }
    
    func partOneSolved(_ limit: Int = 6) -> Int {
        var limit = limit
        let m: Garden  = Garden.from(lines: lines, zero: "_")
        func takeOneStep(_ a: Set<Position>) -> Set<Position> {
            var outSet = Set<Position>()
            for p in a {
                m.ngbrCoordinate(p.r, p.c).forEach { (r,c) in
                    if ".S".contains(m[r,c]!) {
                        outSet.insert(Position(r,c))
                    }
                }
            }
            return outSet
        }
        var cur = Set<Position>([Position(findS(m))])
        while limit > 0 {
            cur = takeOneStep(cur)
            limit -= 1
        }
        return cur.count
    }
    
    func findS(_ m: Garden) -> (UInt, UInt){
        for r in 0...m.height {
            for c in 0...m.width {
                if m[r,c] == "S" {
                    return (r,c)
                }
            }
        }
        fatalError("Can't find S")
    }
    
    struct Position : Hashable, CustomStringConvertible {
        let r: UInt
        let c: UInt
        var description: String {
            "\(r) \(c),"
        }
        
        init(_ r: UInt, _ c: UInt) {
            self.r = r
            self.c = c
        }
        
        init(_ t: (UInt, UInt)) {
            r = t.0
            c = t.1
        }
    }
    enum Direction {
        case right, up, left, down
        
        static func +(lhs: (Int, Int), rhs: Self) -> (Int, Int) {
            switch rhs {
            case .right:
                return (lhs.0, lhs.1 + 1)
            case .up:
                return (lhs.0 - 1, lhs.1)
            case .left:
                return (lhs.0, lhs.1 - 1)
            case .down:
                return (lhs.0 + 1, lhs.1)
            }
        }
    }
    
    
    typealias Garden =  Matrix<Character>
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

extension Day21.Garden {
    func ngbrCoordinate(_ r: UInt, _ c: UInt) -> [(UInt, UInt)] {
        let lst: [Day21.Direction] = [.right, .up, .left, .down]
        return lst.compactMap { d in
            let (rr,cc) = (Int(r),Int(c)) + d
            return validate(rr, cc)
        }
    }
}

