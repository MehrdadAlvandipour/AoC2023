//
//  d17.swift
//  AoC23
//
//  Created by Mehrdad Alvandipour on 1/7/24.
//

import Foundation

struct Day17 {
    let filename = "/Users/mehrdad/workspace/swift_projects/AoC23/Day17/input.txt"
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
        lines = contents.split(omittingEmptySubsequences: true) { $0.isNewline }
    }
    
    init(input: String) {
        let contents = input
        lines = contents.split(omittingEmptySubsequences: true) { $0.isNewline }
    }
    
    func partOne() -> Int {
        let m = readMatrix(lines: lines)
        var pf = PathFinding(m: m)
        pf.shortestPath(0,3)
        return (pf.upper)
    }

    func partTwo() -> Int {
        let m = readMatrix(lines: lines)
        var pf = PathFinding(m: m)
        pf.shortestPath(4,10)
        return (pf.upper)
    }
    
    func readMatrix(lines: [String.SubSequence]) -> Matrix<Int> {
            let w = lines[0].count
            let h = lines.count
            var m = Matrix(h,w, zero: 0, separtor: " ")
            for i in lines.indices {
                for (j,ch) in lines[i].enumerated() {
                    let num = Int(String(ch))!
                    m[i,j] = num
                }
            }
            return m
    }
    
    struct Matrix<Item> : CustomStringConvertible
    where Item: Numeric {
        let height: Int
        let width: Int
        let zero: Item
        let separator: String
        var data: [Item]
        
        
        init(_ height: Int,_ width: Int, zero: Item, separtor: String=",") {
            self.height = height
            self.width = width
            self.zero = zero
            self.separator = separtor
            self.data = [Item](repeating: zero, count: width * height)
        }
        
        func _isValid(_ i: Int,_ j: Int) -> Bool {
            return 0 <= i && i < height && 0 <= j && j < width
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
        
        subscript(_ r: Int, _ c: Int) -> Item? {
            get {
                if !_isValid(r, c) {return nil}
                return data[r*width + c]
            }
            set {
                precondition(_isValid(r, c), "Index out of range")
                data[r*width + c] = newValue!
            }
        }
    }

    enum Orientation: Int {
        case right=0, up, left, down
        
        init?(rawValue: Int) {
            let val = rawValue > 0 ? rawValue % 4 : ((rawValue % 4)+4)%4
            switch val {
            case 0:
                self = .right
            case 1:
                self = .up
            case 2:
                self = .left
            case 3:
                self = .down
            default:
                fatalError("failed to fix rawValue")
            }
        }
        
        func rotate(_ dir: Self) -> Self {
            switch dir {
            case .left:
                return Orientation(rawValue: self.rawValue + 1)!
            case .right:
                return Orientation(rawValue: self.rawValue - 1)!
            default:
                fatalError("wrong rotation")
            }
        }
    }

    struct PathFinding {
        struct State: Hashable {
            let r,c : Int
            let dir: Orientation

            init(_ r: Int, _ c: Int, _ dir:Orientation) {
                self.r = r
                self.c = c
                self.dir = dir
            }

            func rotate(_ rotDir: Orientation) -> Self {
                return State(r,c,dir.rotate(rotDir))
            }

            func move() -> Self { // move 1 step toward o
                switch dir {
                case .right:
                    return State(r,c+1,dir)
                case .up:
                    return State(r-1,c,dir)
                case .left:
                    return State(r,c-1,dir)
                case .down:
                    return State(r+1,c,dir)
                }
            }
        }
        
        struct Candidate {
            let state: State
            let key: Int // is dist + heuristic
            
            static func <(lhs: Candidate, rhs: Candidate) -> Bool {
                return lhs.key < rhs.key
            }
        }

        struct StateSpace {
            let shape: (Int,Int,Int) // height, width, 4
            var data: [Int]

            init(shape: (Int,Int,Int), initVal: Int) {
                self.shape = shape
                self.data = [Int](repeating: initVal,
                    count: self.shape.0 * self.shape.1 * self.shape.2)
            }
            
            subscript(p: State) -> Int {
                get {
                    let (height, width, depth) = shape
                    let (i,j,k) = (p.r, p.c, p.dir.rawValue)
                    precondition(i < height && j < width)
                    return data[i*width*depth + j*depth + k]
                }

                set(newVal) {
                    let (height, width, depth) = shape
                    let (i,j,k) = (p.r, p.c, p.dir.rawValue)
                    precondition(i < height && j < width)
                    data[i*width*depth + j*depth + k] = newVal
                }
                
            }
        }
        
        let transitionCosts: Matrix<Int>
        var upper: Int
        var d: StateSpace

        init(m: Matrix<Int>) {
            self.transitionCosts = m
            self.upper = (m.width + m.height - 2)*9
            self.d = StateSpace(shape: (m.height, m.width, 4), initVal: upper)
        }

        func isValid(_ s: State) -> Bool {
            let (i,j) = (s.r, s.c)
            let (height, width) = (transitionCosts.height, transitionCosts.width)
            return 0 <= i && i < height && 0 <= j && j < width
        }

        func isTerminal(_ p: State) -> Bool {
            return (p.r == transitionCosts.height - 1) &&
                (p.c == transitionCosts.width - 1)
        }
        
        mutating func shortestPath(_ low: Int, _ hi: Int) {
            var OpenCandidates =  Heap<Candidate>(sort: <)
            OpenCandidates.insert(Candidate(state: State(0, 0, .right), key: 0))
            OpenCandidates.insert(Candidate(state: State(0, 0, .down), key: 0))
            self.d[State(0, 0, .right)] =  0
            self.d[State(0, 0, .down)] = 0
            while !OpenCandidates.isEmpty {
                let curCandidate = OpenCandidates.remove()!
                let curState = curCandidate.state

                for rot in [Orientation.left, Orientation.right] { // move perpendicular to current state
                    var newState = curState.rotate(rot)
                    var cost = 0
                    for i in 1...hi { // move up to 'hi' steps
                        newState = newState.move()

                        //all the filters come here
                        if !isValid(newState) {break}
                        cost += transitionCosts[newState.r,newState.c]!
                        if i < low {continue} // move at least 'low' steps

                        let newDistance = self.d[curState] + cost
                        if newDistance >= self.d[newState] {continue}
                        // if doesntPassHeuristic {continue}
                        self.d[newState] = newDistance
                        if !isTerminal(newState) {
                            OpenCandidates.insert(Candidate(state: newState, key: newDistance))
                        } else if newDistance < self.upper {
                            self.upper = newDistance
                        }
                    }
                }
            }
        }
    }
    
}
