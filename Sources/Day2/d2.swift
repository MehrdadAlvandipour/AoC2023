//
//  d2.swift
//  AoC23
//
//  Created by Mehrdad Alvandipour on 12/29/23.
//

import Foundation



struct Day2 {
    var input: String
    var lines: [String.SubSequence]
    let filename = "/Users/mehrdad/workspace/swift_projects/AoC23/Day2/input.txt"
    let limits = ["red": 12,
                   "green": 13,
                   "blue":14]

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
        if contents == "" {
            print("failed to read file")
        }
        return contents
    }
    
    func partOne() -> Int {
        var validGames: [Int] = []
        // let contents = readfile()
        // let lines = (contents).split(separator:"\n")
    outerloop: for line in lines {
        let gameInfo = line.split(separator: ":")
        let gameID = Int(gameInfo[0].split(separator: " ")[1])!
        let gamerounds = gameInfo[1].split(separator: ";")
        for gameround in gamerounds {
            for numColorString in gameround.split(separator: ",") {
                let numColorPair  = numColorString.split(separator: " ")
                let num = Int(numColorPair[0])!
                let color = numColorPair[1]
                if limits[String(color)]! < num {
                    continue outerloop
                }
            }
        }
        validGames.append(gameID)
    }
        return validGames.reduce(0, +)
    }
    
    func partTwo() -> Int {
        var linePower: [Int] = []
        // let contents = readfile()
        // let lines = (contents).split(separator:"\n")
        for line in lines {
            var curMax: [String:Int] = [:]
//            var curMax = [ // I can also initialize instead of the above line
//                "red":0,
//                "blue":0,
//                "green":0
//            ]
            let gameInfo = line.split(separator: ":")
            let gamerounds = gameInfo[1].split(separator: ";")
            for gameround in gamerounds {
                for numColorString in gameround.split(separator: ",") {
                    let numColorPair  = numColorString.split(separator: " ")
                    let num = Int(numColorPair[0])!
                    let color = String(numColorPair[1])
                    curMax[color] = max(num, curMax[color] ?? 0)
                }
            }
            let x = curMax.reduce(1) { (partialResult, keyval) in
                partialResult*keyval.value
            }
            linePower.append(x)
        }
        return (linePower.reduce(0, +))
    }
}
