import XCTest
@testable import AoC2023

final class D24Tests: XCTestCase {
    let input1 = """
19, 13, 30 @ -2,  1, -2
18, 19, 22 @ -1, -1, -2
20, 25, 34 @ -2, -2, -4
12, 31, 28 @ -1, -2, -1
20, 19, 15 @  1, -5, -3
"""

    func testExample() throws {
        let adventDay = Day24(input: input1)
        XCTAssertEqual(adventDay.partOne(), 2)
    }

    func testExample2() throws {
        let adventDay = Day24(input: input1)
        XCTAssertEqual(adventDay.partTwo(), 1)
    }
}
