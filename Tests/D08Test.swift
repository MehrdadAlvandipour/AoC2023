import XCTest
@testable import AoC2023

final class D08Tests: XCTestCase {
    let input1 = """
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
"""
    let input2 = """
LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)
"""
    
    let input3 = """
LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
"""
    func testExample() throws {
        let adventDay = Day8(input: input1)
        XCTAssertEqual(adventDay.partOne(), 2)
    }
    
    func testExample2() throws {
        let adventDay = Day8(input: input2)
        XCTAssertEqual(adventDay.partOne(), 6)
    }

    func testExample3() throws {
        let adventDay = Day8(input: input3)
        XCTAssertEqual(adventDay.partTwo(), 6)
    }
}
