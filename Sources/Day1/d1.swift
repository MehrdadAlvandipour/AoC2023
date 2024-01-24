//
//  d1.swift
//  AoC23
//
//  Created by Mehrdad Alvandipour on 12/29/23.
//

import Foundation

private extension String {
    func index(at offset: Int) -> String.Index {
        index(startIndex, offsetBy: offset)
    }
    
    subscript(value: Int) -> Character {
        self[index(at: value)]
    }
}

struct Day1 {
    var input: String
    var lines: [String.SubSequence]
    let filename = "/Users/mehrdad/workspace/swift_projects/AoC23/Day1/input.txt"
    let englishNums = ["one", "two", "three", "four", "five", "six", "seven", "eight","nine" ]
    let numerals = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
    init(input: String) {
        self.input = input
        self.lines = (input).split(separator:"\n")
    }

    init() {
        self.input = (try? String(contentsOfFile: filename)) ?? ""
        self.lines = (input).split(separator:"\n")
        if input == "" {
            print("failed to read file")
        }
    }

    func readfile() -> String {
        var contents : String
        contents = (try? String(contentsOfFile: filename)) ?? ""
        //    contents = try! String(contentsOfFile: "filename")
        //    do {
        //         contents = try String(contentsOfFile: filename)
        //    } catch {
        //        print(error)
        //        contents = ""
        //    }
        if contents == "" {
            print("failed to read file")
        }
        return contents
    }
    
    func partOne() -> Int {
        // let contents = readfile()
            
        // let lines = (contents).split(separator:"\n")

        var total: Int = 0
        for l in lines {
            var numInLine = ""
            for c in l {
                if numerals.contains(String(c)) {
                    numInLine += String(c)
                    break
                }
            }
            
            for c in l.reversed() {
                if numerals.contains(String(c)) {
                    numInLine += String(c)
                    break
                }
            }
            total += Int(numInLine)!
        }
        return total
    }
    
    func findWordFromLeft(line: String) -> (Int, String)? {
        var lo: Int?
        var word: String = ""
        for num in englishNums {
            if let rng = line.range(of: num) {
                let idx = line.distance(from: line.startIndex, to: rng.lowerBound)
                if idx < lo ?? line.count {
                    lo = idx
                    word = num
                }
            }
        }
        if let lo { return (lo, word)}
        return nil
    }
    

    func findWordFromRight(line: String) -> (Int, String)? {
        var lo: Int?
        var word: String = ""
        for num in englishNums {
            if let rng = String(line.reversed()).range(of: String(num.reversed())) {
                let idx = line.distance(from: line.startIndex, to: rng.upperBound)
                if ( idx < lo ?? line.count) {
                    lo = idx
                    word = num
                }
            }
        }
        if let lo { return (line.count - lo, word)}
        return nil
    }
    
    func firstDigitFromLeft(line: String) -> String {
        var numeralIndex =  -1
        var digit: String = ""
        for (i,c) in line.enumerated() {
            if numerals.contains(String(c)) {
                numeralIndex = i
                digit = String(c)
                break
            }
        }
        if let (idx, word) = findWordFromLeft(line: line) {
            if numeralIndex == -1 || idx < numeralIndex {
//                print(idx, word, line[...String.Index(utf16Offset: idx, in: line)])
                digit = String(englishNums.firstIndex(of: word)! + 1)
            } else {
//                print(numeralIndex)
            }
        }
        
        return digit
    }
    
    func firstDigitFromRight(line: String) -> String {
        var numeralIndex =  line.count
        var digit: String = ""
        for (i,c) in line.reversed().enumerated() {
            if numerals.contains(String(c)) {
                numeralIndex = line.count - i - 1
                digit = String(c)
                break
            }
        }
        if let (idx, word) = findWordFromRight(line: line) {
            if numeralIndex == line.count || idx > numeralIndex {
//                print(idx, word, line[String.Index(utf16Offset: idx, in: line)...])
                digit = String(englishNums.firstIndex(of: word)! + 1)
            } else {
//                print(numeralIndex)
            }
        }
        return digit
    }
    
    
    
    func partTwo() -> Int {
        var total: Int = 0
        for l in lines {
            let x = Int(firstDigitFromLeft(line: String(l))
                         + firstDigitFromRight(line: String(l)))!
            total += x

        }
        return total
        
    }
    
    func sol() -> Int {
        partOne()
    }
    

}







    
    

