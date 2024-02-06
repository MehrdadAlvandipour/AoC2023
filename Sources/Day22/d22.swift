import Foundation

struct Day22 {
    let filename = "/Users/mehrdad/workspace/swift_projects/AoC23/Day22/input.txt"
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
        var x = Bricks(lines)
        x.settle()
        return x.numRemovables()
    }
    
    func partTwo() -> Int {
        var x = Bricks(lines)
        x.settle()
        return x.fallenBricks()
    }
    
    struct Bricks {
        var bricks: [Brick] = []
        var occupied: Set<Vec3> = []
        
        init(_ lines: [some StringProtocol]) {
            for line in lines {
                let vPair = line.split(separator: "~")
                        .map { Vec3($0.split(separator: ",")
                                .map { Int(String($0))!
                        
                                })
                        }
                let zRange = vPair[0].z...vPair[1].z
                self.bricks.append(Brick(a: vPair[0], b: vPair[1], zRange: zRange))
            }
            sortBrick()
        }
        
        mutating func sortBrick() {
            bricks = bricks.sorted(by: { a, b in
                a.zRange.lowerBound < b.zRange.lowerBound
            })
        }
        
        mutating func settle() {
            for i in bricks.indices {
                if bricks[i].zRange.lowerBound == 1 {
                    occupied.formUnion( bricks[i].vol )
                    continue
                }
                var fallOneUnit = bricks[i].move(by: -1)
                while occupied.intersection( fallOneUnit.vol ).isEmpty {
                    bricks[i] = fallOneUnit
                    fallOneUnit = bricks[i].move(by: -1)
                    if fallOneUnit.zRange.lowerBound == 0 { break }
                }
                occupied.formUnion(bricks[i].vol)
            }
        }
        
        func isRemovable(_ i: Int) -> Bool {
            let cur = bricks[i]
            if occupied.subtracting(cur.vol).intersection(cur.move(by: 1).vol).isEmpty { return true }
            for j in (i+1)..<bricks.indices.upperBound {
                let upperBrick = bricks[j]
                if upperBrick.move(by: -1).vol.intersection(cur.vol).isEmpty {
                    continue
                }
                if occupied.subtracting(cur.vol)
                    .subtracting(upperBrick.vol)
                    .intersection(upperBrick.move(by: -1).vol)
                    .isEmpty {
                    return false
                }
            }
            return true
        }
        
        func numRemovables() -> Int {
            var count = 0
            for i in bricks.indices {
                if isRemovable(i) {
                    count += 1
                }
            }
            return count
        }
        
        // TODO PartTwo
        func chain(_ i: Int) -> Int {
            var ans = 0
            let cur = bricks[i]
            if occupied.subtracting(cur.vol).intersection(cur.move(by: 1).vol).isEmpty { return 0 }
            for j in (i+1)..<bricks.indices.upperBound {
                let upperBrick = bricks[j]
                if upperBrick.move(by: -1).vol.intersection(cur.vol).isEmpty {
                    continue
                }
                if occupied.subtracting(cur.vol)
                    .subtracting(upperBrick.vol)
                    .intersection(upperBrick.move(by: -1).vol)
                    .isEmpty {
                    ans += chain(j) + 1 // Wrong
                }
            }
            return ans
        }
        
        func fallenBricks() -> Int {
            var count = 0
            for i in bricks.indices {
                count += chain(i)
            }
            return count
        }
    }
    
    struct Brick: CustomStringConvertible {
        let a: Vec3
        let b: Vec3
        let zRange: ClosedRange<Int>
        let vol: Set<Vec3>
        var description: String {
            "\(a) to \(b) | z:\(zRange) | vol: \(vol)"
        }
        
        init(a: Vec3, b: Vec3, zRange: ClosedRange<Int>) {
            self.a = a
            self.b = b
            self.zRange = a.z...b.z
            self.vol = Self.fill(from: a, to: b)
        }
        
        static func fill(from: Vec3, to: Vec3) -> Set<Vec3> {
            var volume: Set<Vec3> = []
            for x in from.x...to.x {
                for y in from.y...to.y {
                    for z in from.z...to.z {
                        volume.insert(Vec3(x,y,z))
                    }
                }
            }
            return volume
        }
        
        func move(by dz: Int) -> Self {
            Brick(a: a + Vec3(0,0,dz),
                  b: b + Vec3(0,0,dz),
                  zRange: (zRange.lowerBound + dz)...(zRange.upperBound + dz))
        }
    }
    
    struct Vec3: CustomStringConvertible, Hashable {
        let x: Int
        let y: Int
        let z: Int
        var description: String {
            "(\(x), \(y), \(z))"
        }
        
        init(_ v: [Int]) {
            if v.count != 3 { fatalError("not v3") }
            self.x = v[0]
            self.y = v[1]
            self.z = v[2]
        }
        
        init(_ x: Int, _ y: Int, _ z: Int) {
            self.x = x
            self.y = y
            self.z = z
        }
        
        static func -(lhs: Self, rhs: Self) -> Self {
            return Vec3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
        }
        
        static func +(lhs: Self, rhs: Self) -> Self {
            return Vec3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
        }
        
        func norm() -> Double {
            sqrt(Double((x*x) + (y*y) + (z*z)))
        }
    }
}
