import Foundation

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
        var limit = 26501365
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
//        print(cur)
//        var stack: [(UInt, (UInt, UInt))] = [(0, findS(m))]
//        var visited = Set<Position>()
//        var ans = 0
//        while !stack.isEmpty {
//            let (step, cur) = stack.popLast()!
//            if step >= limit {
//                visited.insert(Position(cur))
//                ans += 1
//                continue
//            }
//            for (r,c) in m.ngbrCoordinate(cur.0, cur.1) {
//                if ".S".contains(m[r,c]!) { // !visited.contains(Position(r,c))
//                    stack.append((step+1, (r,c)))
////                    visited.insert(Position(cur))
//                }
//            }
//        }
        return cur.count
    }
    
    func takeOneStep() {
        
    }
    
    func partTwo() -> Int {
        return 1
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

