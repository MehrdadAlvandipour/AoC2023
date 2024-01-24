//
//  d7.swift
//  AoC23
//
//  Created by Mehrdad Alvandipour on 12/30/23.
//

import Foundation

private extension [Int] {
    static func <(lhs: [Int], rhs: [Int]) -> Bool {     // simple lexiographic ordering on arrays
        for i in 0..<Swift.min(lhs.count, rhs.count) {  // when one is larger, size will be our last resort
            if lhs[i] == rhs[i] {continue}              // as if assuming shorter one is extended with empty elements
            return lhs[i] < rhs[i]                      // which are surely < any other character.
        }
        return lhs.count < rhs.count
    }
}

private extension String {
    func getFirstIndex(of: Character) -> Int? {
        return self.firstIndex(of: of)?.utf16Offset(in: self)
    }
    
    func at(_ idx: Int) -> Character? {
        if idx >= self.count || idx < 0 {
            return nil
        }
        return self[String.Index(utf16Offset: idx, in: self)]
    }
}

enum HandType: Comparable {
    case HighCard
    case OnePair
    case TwoPair
    case Three
    case FullHouse
    case Four
    case Five
}

struct Hand : CustomStringConvertible{
    let bid: Int
    let handString: String
    let handDict: [Character:Int]
    let handType: HandType
    var numericalRep: [Int] = [Int](repeating: 0, count: 5)
    

    let hasJoker: Bool
    var handTypeWIthJoker: HandType {
        if !hasJoker || handType == .Five{return handType}
        switch handType {
        case .HighCard:
            return .OnePair
        case .OnePair:
            return .Three
        case .TwoPair:
            if handDict["J"]! > 1 {
                return .Four
            } else {
                return .FullHouse
            }
        case .Three:
            return .Four
        case .FullHouse:
            return .Five
        case .Four:
            return .Five
        default:
            print("never here")
            return .Five
        }
    }
    
    var description: String { return "\(handString) \(handType)" } // print repr. requires CustomStringConvertible protocole
    
    init(bid: Int, handString: String, cardValue: [Character:Int]) {
        self.bid = bid
        self.handString = handString
        self.handDict = handString.reduce([:]) { (d, c) -> Dictionary<Character,Int> in
            var d = d
            d[c] = (d[c] ?? 0) + 1
            return d
        }
        if handString.contains("J") {
            self.hasJoker = true
        } else {
            self.hasJoker = false
        }

        switch handDict.values.sorted() {
        case [1,1,1,1,1]:
            self.handType = .HighCard
        case [1,1,1,2]:
            self.handType = .OnePair
        case [1,2, 2]:
            self.handType = .TwoPair
        case [1,1,3]:
            self.handType = .Three
        case [2,3]:
            self.handType = .FullHouse
        case [1,4]:
            self.handType = .Four
        case [5]:
            self.handType = .Five
        default:
            self.handType = .HighCard
            print("should not happen")
        }

        for (i,c) in handString.enumerated() {
            numericalRep[i] = cardValue[c]!
        }
    }
}

struct Day7 {
    let filename = "/Users/mehrdad/workspace/swift_projects/AoC23/Day7/input.txt"
    var lines: [String.SubSequence] = []
    
    func readfile() -> String {
        var contents : String
        contents = (try? String(contentsOfFile: filename)) ?? ""
        if contents == "" {
            print("failed to read file")
        }
        return contents
    }
    
    init() {
        let contents = readfile()
        lines = (contents).split(separator:"\n")
    }
    
    init(input: String) {
        let contents = input
        lines = (contents).split(separator:"\n")
    }
    
    func partOne() -> Int {
        var hands: [Hand] = []
        let cv: [Character:Int] = [
            "2": 2, "3": 3, "4":4, "5":5, "6":6, "7":7, "8":8, "9":9, "T": 10,
            "J": 11, "Q":12, "K":13, "A":14]
        for line in lines {
            let hb = line.split(separator: " ")
            hands.append(Hand(bid: Int(hb[1])!, handString: String(hb[0]), cardValue: cv))
        }
        
        let sortedHands = hands.sorted { lhs, rhs in
            if lhs.handType == rhs.handType {
                return lhs.numericalRep < rhs.numericalRep
            } else {
                return lhs.handType < rhs.handType
            }
        }

        var winnings = 0
        for (i, h) in sortedHands.enumerated() {
            winnings += ((i+1) * h.bid)
        }
        return (winnings)
    }
    
    func partTwo() -> Int {
        var hands: [Hand] = []
        let cvJoker: [Character:Int] = [
            "J": 1, "2": 2, "3": 3, "4":4, "5":5, "6":6, "7":7, "8":8, "9":9, "T": 10,
            "Q":12, "K":13, "A":14]
        for line in lines {
            let hb = line.split(separator: " ")
            hands.append(Hand(bid: Int(hb[1])!, handString: String(hb[0]), cardValue: cvJoker))
        }
        let sortedHands = hands.sorted { lhs, rhs in
            if lhs.handTypeWIthJoker == rhs.handTypeWIthJoker {
                return lhs.numericalRep < rhs.numericalRep
            } else {
                return lhs.handTypeWIthJoker < rhs.handTypeWIthJoker
            }
        }

        var winnings = 0
        for (i, h) in sortedHands.enumerated() {
            winnings += ((i+1) * h.bid)
        }
        return (winnings)
    }

}
