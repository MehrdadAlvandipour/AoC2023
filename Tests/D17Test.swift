import XCTest
@testable import AoC2023

final class D17Tests: XCTestCase {
    let input1 = """
2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533
"""
    
    let input2 = """
111111111111
999999999991
999999999991
999999999991
999999999991
"""
    func testExample() throws {
        let adventDay = Day17(input: input1)
        XCTAssertEqual(adventDay.partOne(), 102)
    }

    func testExample2() throws {
        let adventDay = Day17(input: input1)
        XCTAssertEqual(adventDay.partTwo(), 94)
    }
    
    func testExample3() throws {
        let adventDay = Day17(input: input2)
        XCTAssertEqual(adventDay.partTwo(), 71)
    }
}
