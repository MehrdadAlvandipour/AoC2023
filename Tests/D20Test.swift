import XCTest
@testable import AoC2023

final class D20Tests: XCTestCase {
    let input1 = """
broadcaster -> a, b, c
%a -> b
%b -> c
%c -> inv
&inv -> a
"""
    
    let input2 = """
broadcaster -> a
%a -> inv, con
&inv -> b
%b -> con
&con -> output
"""
    func testExample() throws {
        let adventDay = Day20(input: input1)
        XCTAssertEqual(adventDay.partOne(), 32000000)
    }

    func testExample2() throws {
        let adventDay = Day20(input: input2)
        XCTAssertEqual(adventDay.partOne(), 11687500)
    }
}
