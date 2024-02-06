import XCTest
@testable import AoC2023

final class D22Tests: XCTestCase {
    let input1 = """
1,0,1~1,2,1
0,0,2~2,0,2
0,2,3~2,2,3
0,0,4~0,2,4
2,0,5~2,2,5
0,1,6~2,1,6
1,1,8~1,1,9
"""

    func testExample() throws {
        let adventDay = Day22(input: input1)
        XCTAssertEqual(adventDay.partOne(), 5)
    }

    func testExample2() throws {
        let adventDay = Day22(input: input1)
        XCTAssertEqual(adventDay.partTwo(), 7)
    }
}
