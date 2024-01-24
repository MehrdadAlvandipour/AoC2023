import XCTest
@testable import AoC2023

final class D10Tests: XCTestCase {
    
    let input1 = """
.....
.S-7.
.|.|.
.L-J.
.....
"""
    
    let input2 = """
..F7.
.FJ|.
SJ.L7
|F--J
LJ...
"""
    
    let input3 = """
...........
.S-------7.
.|F-----7|.
.||.....||.
.||.....||.
.|L-7.F-J|.
.|..|.|..|.
.L--J.L--J.
...........
"""
    
    let input4 = """
.F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ...
"""
    
    let input5 = #"""
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L
"""#
    
    func testExample1() throws {
        let adventDay = Day10(input: input1)
        XCTAssertEqual(adventDay.partOne(), 4)
    }
    
    func testExample2() throws {
        let adventDay = Day10(input: input2)
        XCTAssertEqual(adventDay.partOne(), 8)
    }
    
    func testExample3() throws {
        let adventDay = Day10(input: input3)
        XCTAssertEqual(adventDay.partTwo(), 4)
    }
    
    func testExample4() throws {
        let adventDay = Day10(input: input4)
        XCTAssertEqual(adventDay.partTwo(), 8)
    }
    
    func testExample5() throws {
        let adventDay = Day10(input: input5)
        XCTAssertEqual(adventDay.partTwo(), 10)
    }
}
