import XCTest
@testable import AoC2023

final class D13Tests: XCTestCase {
    let input1 = """
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
"""
    func testExample() throws {
        let adventDay = Day13(input: input1)
        XCTAssertEqual(adventDay.partOne(), 405)
    }
    
    func testExample2() throws {
        let adventDay = Day13(input: input1)
        XCTAssertEqual(adventDay.partTwo(), 400)
    }
    
}
