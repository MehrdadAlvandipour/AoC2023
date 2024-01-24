import XCTest
@testable import AoC2023

final class D16Tests: XCTestCase {
    let input1 = #"""
.|...\....
|.-.\.....
.....|-...
........|.
..........
.........\
..../.\\..
.-.-/..|..
.|....-|.\
..//.|....
"""#
    func testExample() throws {
        let adventDay = Day16(input: input1)
        XCTAssertEqual(adventDay.partOne(), 46)
    }
    
    func testExample2() throws {
        let adventDay = Day16(input: input1)
        XCTAssertEqual(adventDay.partTwo(), 51)
    }
    
}
