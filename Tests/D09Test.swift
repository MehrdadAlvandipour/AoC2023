import XCTest
@testable import AoC2023

final class D09Tests: XCTestCase {
    let input1 = """
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
"""
    let input2 = """
LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)
"""
    func testExample() throws {
        let adventDay = Day9(input: input1)
        XCTAssertEqual(adventDay.partOne(), 114)
    }
    
    func testExample2() throws {
        let adventDay = Day9(input: input1)
        XCTAssertEqual(adventDay.partTwo(), 2)
    }
}
