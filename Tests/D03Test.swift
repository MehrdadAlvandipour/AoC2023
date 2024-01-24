import XCTest
@testable import AoC2023

final class D03Tests: XCTestCase {
    let test1 = """
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
"""
    func testExample() throws {
        let adventDay = Day3(input: test1)
        XCTAssertEqual(adventDay.partOne(), 4361)
    }

    func testExample2() throws {
        let adventDay = Day3(input: test1)
        XCTAssertEqual(adventDay.partTwo(), 467835)
    }
}
