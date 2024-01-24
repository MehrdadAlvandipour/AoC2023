//
//  d5.swift
//  AoC23
//
//  Created by Mehrdad Alvandipour on 12/29/23.
//

import Foundation



private extension Int {
    func applyMap(_ m: [DSL]) -> Int {
        if let intervalIndex = linearSearch(for: self, on: m, with: {(dsl) in dsl.source}) {
            return computeAffine(mapping: m[intervalIndex], of: self)
        } else {
            return self
        }
    }
    
    func applyInverseMap(_ m: [DSL]) -> Int {
        if let intervalIndex = linearSearch(for: self, on: m, with: {(dsl) in dsl.destination}) {
            return computeInverseAffine(mapping: m[intervalIndex], of: self)
        } else {
            return self
        }
    }
}

extension [Int] {
    func foreward(_ m: [DSL]) -> [Int] {
        return self.map { x in
            x.applyMap(m)
        }
    }
    func backward(_ m: [DSL]) -> [Int] {
        return self.map { x in
            x.applyInverseMap(m)
        }
    }
    
    func backwardAndJoinSource(_ m: [DSL]) -> [Int] {
        var a = self.backward(m)
        a.append(contentsOf: sourcePoints(m))
        return a
    }
}

func sourcePoints(_ m: [DSL]) -> [Int] {
    var src: [Int] = []
    for dsl in m {
        src.append(dsl.source)
        src.append(dsl.source + dsl.length)
    }
    return src
}

func destinationPoints(_ m: [DSL]) -> [Int] {
    var dst: [Int] = []
    for dsl in m {
        dst.append(dsl.destination)
        dst.append(dsl.destination + dsl.length)
    }
    return dst
}


func linearSearch(for x: Int, on m: [DSL], with key: (DSL) -> Int) -> Int? {
    for (i, dsl) in m.enumerated() {
        if (key(dsl) <= x) && (x <= key(dsl) + (dsl.length - 1)) {
            return i
        }
    }
    return nil
}

func binarySearch(for x: Int, on m: [DSL], with key: (DSL) -> Int) -> Int? {
    var lo = 0
    var hi = m.count - 1
    var mid: Int
    while lo < hi {
        mid = lo + (hi - lo) / 2
        let lowerBound = key(m[mid]) // m[mid].source
        let upperBound = key(m[mid]) + m[mid].length - 1
        if lowerBound <= x && x <= upperBound {
            return mid
        }
        if x > upperBound {
            lo = mid + 1
        } else {
            hi = mid - 1
        }
    }
    if hi == lo && lo >= 0 && lo <= m.count - 1 {
        if key(m[lo]) <= x && x <= (key(m[lo]) + m[lo].length - 1) {
            return lo
        } else {
            return nil
        }
    }
    return nil
}

func computeAffine(mapping m: DSL, of x: Int) -> Int {
    return m.destination + (x - m.source)
}

func computeInverseAffine(mapping m: DSL, of x: Int) -> Int {
    return m.source + (x - m.destination)
}


struct DSL {
    let destination: Int
    let source: Int
    let length: Int

    init(arr: [Int]) {
        destination = arr[0]
        source = arr[1]
        length = arr[2]
    }
}

struct Day5 {
    let filename = "/Users/mehrdad/workspace/swift_projects/AoC23/Day5/input.txt"
    let lines: [String.SubSequence]
    
    init() {
        let contents = readfile(filename)
        lines = (contents).split(separator:"\n")
    }
    
    init(input: String) {
        let contents = input
        lines = (contents).split(separator:"\n")
    }
    
    func partOne() -> Int {
        var sf = SeedFertilizer(lines: lines)
        return sf.partOne()
    }
    
    func partTwo() -> Int {
        var sf = SeedFertilizer(lines: lines)
        return sf.partTwo()
    }
    
    struct SeedFertilizer {
        let lines: [String.SubSequence]
        var seeds: [Int] = []
        var maps: [String:[DSL]] = [:]
        
        init(lines: [String.SubSequence]) {
            self.lines = lines
        }
        
        mutating func readSeed() {
            seeds = lines[0].split(separator: ":")[1].split(separator: " ").map { Substring in
                Int(Substring)!
            }
        }
        
        mutating func populateMap() {
            var key = ""
            for line in lines[1...] {
                switch (line) {
                case "seed-to-soil map:":
                    key = "seed-to-soil"
                    continue
                case "soil-to-fertilizer map:":
                    key = "soil-to-fertilizer"
                    continue
                case "fertilizer-to-water map:":
                    key = "fertilizer-to-water"
                    continue
                case "water-to-light map:":
                    key = "water-to-light"
                    continue
                case "light-to-temperature map:":
                    key = "light-to-temperature"
                    continue
                case "temperature-to-humidity map:":
                    key = "temperature-to-humidity"
                    continue
                case "humidity-to-location map:":
                    key = "humidity-to-location"
                    continue
                case "":
                    continue
                default:
                    ()
                }
                if !maps.keys.contains(key) {
                    maps[key] = []
                }
                let arr = line.split(separator: " ").map({ Substring in
                    Int(Substring)!
                })
                maps[key]!.append(DSL(arr: arr))
            }
        }
        
        mutating func sortMap(key: (DSL) -> Int) {
            for (k,v) in maps {
                maps[k] = v.sorted(by: { a, b in
                    key(a) <= key(b)
                })
            }
        }
        
        func applyAllMaps(to arr: [Int]) -> [Int] {
            return arr.foreward(maps["seed-to-soil"]!)
            .foreward(maps["soil-to-fertilizer"]!)
            .foreward(maps["fertilizer-to-water"]!)
            .foreward(maps["water-to-light"]!)
            .foreward(maps["light-to-temperature"]!)
            .foreward(maps["temperature-to-humidity"]!)
            .foreward(maps["humidity-to-location"]!)
        }
        
        mutating func partOne() -> Int {
            readSeed()
            populateMap()
            sortMap { dsl in
                dsl.source
            }

            let locations = applyAllMaps(to: seeds)
    //        print(locations)
            return (locations.min()!)
        }
        
        
        func applyAllInverseMaps(to arr: [Int]) -> [Int] {
            return arr.backward(maps["humidity-to-location"]!)
                .backward(maps["temperature-to-humidity"]!)
                .backward(maps["light-to-temperature"]!)
                .backward(maps["water-to-light"]!)
                .backward(maps["fertilizer-to-water"]!)
                .backward(maps["soil-to-fertilizer"]!)
                .backward(maps["seed-to-soil"]!)
        }
        
        
        func findAllBreakpoints() -> [Int] {
            return sourcePoints(maps["humidity-to-location"]!)
                .backwardAndJoinSource(maps["temperature-to-humidity"]!)
                .backwardAndJoinSource(maps["light-to-temperature"]!)
                .backwardAndJoinSource(maps["water-to-light"]!)
                .backwardAndJoinSource(maps["fertilizer-to-water"]!)
                .backwardAndJoinSource(maps["soil-to-fertilizer"]!)
                .backwardAndJoinSource(maps["seed-to-soil"]!)
        }
        
        func inROI(_ x: Int) -> Bool {
            var leftIndex = 0
            while leftIndex < seeds.count {
                if seeds[leftIndex] <= x &&
                    x <= (seeds[leftIndex] + seeds[leftIndex + 1]) {
                    return true
                }
                leftIndex += 2
            }
            return false
        }
        
        mutating func partTwo() -> Int {
            readSeed()
            populateMap()
            sortMap { dsl in dsl.source }
            
            let filteredEndpoints = Array<Int>(Set(findAllBreakpoints()))
                .filter(inROI)
            let res = applyAllMaps(to: filteredEndpoints)
            return (res.min()!)
        }
    }
}
