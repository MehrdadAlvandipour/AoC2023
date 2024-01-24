import XCTest
@testable import AoC2023

final class D07Tests: XCTestCase {
    let input1 = """
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
"""
    func testExample() throws {
        let adventDay = Day7(input: input1)
        XCTAssertEqual(adventDay.partOne(), 6440)
    }

    func testExample2() throws {
        let adventDay = Day7(input: input1)
        XCTAssertEqual(adventDay.partTwo(), 5905)
    }
}
