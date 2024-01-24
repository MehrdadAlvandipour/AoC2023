import XCTest
@testable import AoC2023

final class D06Tests: XCTestCase {
    let input1 = """
Time:      7  15   30
Distance:  9  40  200
"""
    func testExample() throws {
        let adventDay = Day6(input: input1)
        XCTAssertEqual(adventDay.partOne(), 288)
    }

    func testExample2() throws {
        let adventDay = Day6(input: input1)
        XCTAssertEqual(adventDay.partTwo(), 71503)
    }
}
