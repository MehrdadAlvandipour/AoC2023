import XCTest
@testable import AoC2023

final class D12Tests: XCTestCase {
    let input1 = """
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
"""
    func testExample() throws {
        let adventDay = Day12(input: input1)
        XCTAssertEqual(adventDay.partOne(), 21)
    }
    
    func testExample2() throws {
        let adventDay = Day12(input: input1)
        XCTAssertEqual(adventDay.partTwo(), 525152)
    }
    
}
