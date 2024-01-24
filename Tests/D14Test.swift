import XCTest
@testable import AoC2023

final class D14Tests: XCTestCase {
    let input1 = """
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
"""
    func testExample() throws {
        let adventDay = Day14(input: input1)
        XCTAssertEqual(adventDay.partOne(), 136)
    }
    
    func testExample2() throws {
        let adventDay = Day14(input: input1)
        XCTAssertEqual(adventDay.partTwo(), 64)
    }
    
}
