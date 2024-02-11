import Foundation

struct Day24 {
    let filename = "/Users/mehrdad/workspace/swift_projects/AoC23/Day24/input.txt"
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
        p1(200000000000000, 400000000000000)
    }
    
    func p1(_ lower: Int, _ upper: Int) -> Int{
//        print(lines.count)
//        print(Int.max)
//        print(Float.greatestFiniteMagnitude)
        let x = Particles(lines, lower, upper)
        
        var ans = 0
        for i in x.pvArray.indices {
            for j in i..<x.pvArray.count {
                if let p = x.intersectLines2D(i, j) {
//                    print(p, x.isIn2D(p) , x.collide(i,j,p))
                    ans += x.isIn2D(p) && x.collide(i,j,p) ? 1 : 0
                }
            }
        }
        
//        print(x.limitX, x.limitY)
//        print(x.Origin)
        return ans
    }
    
    func partTwo() -> Int {
        // solved in python for now.
        //        14672
        //        646810057104753
        646810057104753
    }
    
    
    
    struct Matrix2 {
        let a: Float
        let b: Float
        let c: Float
        let d: Float
        
        init(_ a:Float, _ b:Float, _ c:Float, _ d:Float) {
            self.a = a
            self.b = b
            self.c = c
            self.d = d
        }
        
        func mult(_ x: Float, _ y:Float) -> Vec2<Float> {
            let x1 = a*x + b*y
            let y1 = c*x + d*y
            return Vec2(x1,y1)
        }
        
        func scale(_ sc: Float) -> Self {
            Matrix2(a*sc, b*sc, c*sc, d*sc)
        }
        
        func det() -> Float {
            a*d - b*c
        }
        
        func inv() -> Self {
            Matrix2(d, -b, -c, a).scale(1.0 / det() )
        }
        
        func inv(_ determinant: Float) -> Self {
            Matrix2(d, -b, -c, a).scale(1.0 / determinant)
        }
    }
    
    struct Particles {
        var pvArray: [[Vec3]]
        var Origin: Vec3 = Vec3(0,0,0)
        var limitX: ClosedRange<Int> = 0...0
        var limitY: ClosedRange<Int> = 0...0
        
        init(_ lines: [String.SubSequence], _ lower: Int, _ upper: Int) {
            pvArray = lines.map { Particles.parseLine($0) }
            Origin = findOrigin()
            pvArray = pvArray.map { [$0[0] - Origin, $0[1]] }
            limitX = ClosedRange(uncheckedBounds: (lower: lower - Origin.x,
                                                   upper: upper - Origin.x))
            limitY = ClosedRange(uncheckedBounds: (lower: lower - Origin.y,
                                                   upper: upper - Origin.y))
        }
        
        static func parseLine(_ line: some StringProtocol) -> [Vec3] {
            let pv = line.split(separator: "@")
                .map { $0.split(separator: ",")
                        .map { Int($0.trimmingCharacters(in: [" "]))!
                            
                        }.toVec3()
            }
            return pv
        }
    
        func findOrigin() -> Vec3 {
            var minX: Int = Int.max
            var minY: Int = Int.max
            var minZ: Int = Int.max
            pvArray.forEach { pv in
                minX = min(pv[0].x, minX)
                minY = min(pv[0].y, minY)
                minZ = min(pv[0].z, minZ)
            }
            return Vec3(minX, minY, minZ)
        }
        
        func collide(_ i: Int, _ j: Int, _ p: Vec2<Float>) -> Bool {
            let p1 = Vec2<Float>(Float(pvArray[i][0].x), Float(pvArray[i][0].y))
            let p2 = Vec2<Float>(Float(pvArray[j][0].x), Float(pvArray[j][0].y))
            let v1 = Vec2<Float>(Float(pvArray[i][1].x), Float(pvArray[i][1].y))
            let v2 = Vec2<Float>(Float(pvArray[j][1].x), Float(pvArray[j][1].y))
            
            return dot(p - p1, v1) > 0 && dot(p-p2, v2) > 0
            
        }
        
        func dot(_ a: Vec2<Float>, _ b: Vec2<Float>) -> Float {
            a.x * b.x + a.y * b.y
        }
        
        func isIn2D(_ p: Vec2<Float>) -> Bool {
            Float(limitX.lowerBound) <= p.x && Float(limitX.upperBound) >= p.x &&
            Float(limitY.lowerBound) <= p.y && Float(limitY.upperBound) >= p.y
        }
        
        func intersectInArea(_ i: Int, _ j: Int) -> Vec2<Float>? {
            if let int = intersectLines2D(i, j), isIn2D(int) {
                 return int
            }
            return nil
        }
        
        func intersectLines2D(_ i: Int, _ j: Int) -> Vec2<Float>? {
            let pv1 = pvArray[i]
            let pv2 = pvArray[j]
            let v1 = pv1[1]
            let v2 = pv2[1]
            let p1 = pv1[0]
            let p2 = pv2[0]
            let sys = Matrix2(Float(-v1.y), Float(v1.x), Float(-v2.y), Float(v2.x))
            if (sys.det().isZero) {return nil}
            let k1 = v1.x * p1.y - v1.y * p1.x
            let k2 = v2.x * p2.y - v2.y * p2.x
            return (sys.inv().mult(Float(k1), Float(k2)))
        }
    }
    
    
    
    struct Vec3: CustomStringConvertible {
        let x: Int
        let y: Int
        let z: Int
        var description: String {
            "[\(x) \(y) \(z)]"
        }
        
        init(_ x: Int, _ y: Int, _ z: Int) {
            self.x = x
            self.y = y
            self.z = z
        }
        
        init(_ arr: ArraySlice<Int>) {
            self.x = arr[0]
            self.y = arr[1]
            self.z = arr[2]
        }
        
        static func -(lhs: Self, rhs: Self) -> Self {
            Self(lhs.x - rhs.x, lhs.y-rhs.y, lhs.z - rhs.z)
        }
    }
    
    struct Vec2<Item: FloatingPoint>: CustomStringConvertible {
        let x: Item
        let y: Item
        var description: String {
            "[\(x) \(y)]"
        }
        
        init(_ x: Item, _ y: Item) {
            self.x = x
            self.y = y
        }
        
        init(_ arr: ArraySlice<Item>) {
            self.x = arr[0]
            self.y = arr[1]
        }
        
        static func -(lhs: Self, rhs: Self) -> Self {
            Self(lhs.x - rhs.x, lhs.y-rhs.y)
        }
    }
    
}


private extension [Int] {
    func toVec3() -> Day24.Vec3 {
        Day24.Vec3(self[0...2])
    }
}
