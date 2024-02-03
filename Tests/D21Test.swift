import XCTest
@testable import AoC2023

final class D21Tests: XCTestCase {
    let input1 = """
...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
...........
"""
    
//    let input2 = """
//broadcaster -> a
//%a -> inv, con
//&inv -> b
//%b -> con
//&con -> output
//"""
    func testExample() throws {
        let adventDay = Day21(input: input1)
        XCTAssertEqual(adventDay.partOne(), 16)
    }

//    func testExample2() throws {
//        let adventDay = Day21(input: input2)
//        XCTAssertEqual(adventDay.partOne(), 11687500)
//    }
}
