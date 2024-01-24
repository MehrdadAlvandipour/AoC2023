import XCTest
@testable import AoC2023

final class D01Tests: XCTestCase {
    let test1 = """
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
"""

    let test2: String = """
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
"""
    func testExample() throws {
        let adventDay = Day1(input: test1)
        XCTAssertEqual(adventDay.partOne(), 142)
    }

    func testExample2() throws {
        let adventDay = Day1(input: test2)
        XCTAssertEqual(adventDay.partTwo(), 281)
    }
}
