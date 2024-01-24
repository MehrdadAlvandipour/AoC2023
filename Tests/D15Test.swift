import XCTest
@testable import AoC2023

final class D15Tests: XCTestCase {
    let input1 = """
rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
"""
    func testExample() throws {
        let adventDay = Day15(input: input1)
        XCTAssertEqual(adventDay.partOne(), 1320)
    }
    
    func testExample2() throws {
        let adventDay = Day15(input: input1)
        XCTAssertEqual(adventDay.partTwo(), 145)
    }
    
}
