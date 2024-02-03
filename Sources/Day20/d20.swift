import Collections

struct Day20 {
    let filename = "/Users/mehrdad/workspace/swift_projects/AoC23/Day20/input.txt"
    let lines: [String.SubSequence]
    
    init() {
        let contents = readfile(filename)
        lines = contents.split(omittingEmptySubsequences: false) { $0.isNewline }
    }
    
    init(input: String) {
        let contents = input
        lines = contents.split() { $0.isNewline }
    }
    
    func partOne() -> Int {
        var x = ModuleGraph(lines: lines)
        return x.p1()
    }
    
    func partTwo() -> Int {
        var x = ModuleGraph(lines: lines)
        return x.p2()
    }
    
    struct ModuleGraph : CustomStringConvertible {
        var inputs: [String: [String]] = [:]
        fileprivate var graph: [String: any Mod ] = [:]
        var description: String {
            var des = ""
            for (k,n) in graph {
                des +=  "\(k): \(n.description) \n"
            }
            return des
        }
        
        init(lines: [String.SubSequence]) {
            for line in lines {
                let (t, n, outputs) = (parse(line: line))
                switch t {
                case "%":
                    graph[n] = Flip(outputs: outputs)
                case "&":
                    graph[n] = Conj(outputs: outputs)
                case "b":
                    graph[n] = Broadcaster(outputs: outputs)
                default:
                    fatalError("never here!")
                }
                
                for o in outputs {
                    inputs[o, default: []].append(n)
                }
            }
            for (k, ins) in inputs {
                graph[k]?.addInputs(ins)
            }
        }
        
        func parse(line: some StringProtocol) -> (nodeType: Character, name: String, outputs: [String]) {
            let x = line.split(separator: ">")
            let TypeNode = x[0].trimmingCharacters(in: ["-", " "])
            let outputs = x[1]
                .trimmingCharacters(in: [" "])
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: [" "]) }
            let nodeType = TypeNode.first! as Character
            let name = nodeType == "b" ? TypeNode : String(TypeNode.dropFirst(1))
            return (nodeType, name, outputs)
        }
        
        func cycleFinished() -> Bool {
            graph.values.allSatisfy { $0.isInOriginalState() }
        }
        
        mutating func p1() -> Int {
            var scores: [Signal: Int] = [.low: 0, .high: 0]
            var q = Deque<(String, Signal, String)>()
            
            var counter = 0
            repeat {
                counter += 1
                q.append(("Button", .low, "broadcaster"))
                while !q.isEmpty {
                    let (parent, sig, n) = q.popFirst()!
                    scores[sig]! += 1
                    if let res = graph[n]?.apply(from: parent, signal: sig) {
                        graph[n]!.outputs.forEach { q.append((n, res, $0 )) }
                    }
                }
            } while !cycleFinished() && counter < 1000
//            print("Counter: ", counter, scores)
            // For the test cases and the problem in hand, this is enough
            // but in the general case 1000/counter might have a residue,
            // and you need to press the button 1000%counter after 1000/counter full cycles.
            // In that case, scores from the leftover phase must be added to below.
            return (scores.values.reduce(1, *) * (1000/counter) * (1000/counter))
        }
        
//        Helper method for looking at parents
//        var visited = Set<String>()
//        mutating func printParents(_ n: String) {
//            visited.insert(n)
//            print(n, inputs[n])
//            for x in inputs[n] ?? [] {
//                if visited.contains(x) {continue}
//                printParents(x)
//            }
//        }
        
        mutating func p2() -> Int {
            let inp = inputs["rx"]!.first! // This is a single conjunction node "kc"
            var inpHit: [String:Int] = [:] // its parents: ["ph", "hn", "kt", "vn"]
            // each seem to have a fixed period,
            // so the LCM of their periods is the ans to part2
            var q = Deque<(String, Signal, String)>()
            var counter = 0
            repeat {
                counter += 1
                q.append(("Button", .low, "broadcaster"))
                while !q.isEmpty {
                    let (parent, sig, n) = q.popFirst()!
                    if let res = graph[n]?.apply(from: parent, signal: sig) {
                        if n == inp && sig == .high {
                            inpHit[parent] = counter
                            print(parent, inpHit[parent]!, (graph[n] as! Conj).hist)
                            if inpHit.count == 4 {
                                return (inpHit.values.reduce(1, *))
                            }
                        }
                        graph[n]!.outputs.forEach { q.append((n, res, $0 )) }
                    }
                }
            } while !cycleFinished()
            fatalError("never here")
        }
    }
    
    
    enum Signal:Int, CustomStringConvertible {
        case low=0,high
        var description: String {
            "\(self.rawValue)"
        }
    }
    
    enum ModState {
        case on,off
    }
    
    struct Broadcaster: Mod {
        let type: Character = "b"
        let outputs: [String]
        
        init(outputs: [String]) {
            self.outputs = outputs
        }
        
        mutating func apply(from: String, signal: Day20.Signal) -> Day20.Signal? {
            return signal
        }
        
        mutating func addInputs(_ ins: [String]) {
            
        }
        
        func isInOriginalState() -> Bool {
            return true
        }
    }
    
    struct Flip : Mod {
        let type: Character = "%"
        let outputs: [String]
        var description: String {
            "\(inputs) \(type) \(outputs)"
        }
        var state: ModState = .off
        var inputs: [String] = []
        
        init(outputs: [String]) {
            self.outputs = outputs
        }
        
        mutating func apply(from: String, signal: Day20.Signal) -> Day20.Signal? {
            switch signal {
            case .high:
                return nil
            case .low:
                switch state {
                case .off:
                    state = .on
                    return .high
                case .on:
                    state = .off
                    return .low
                }
            }
        }
        
        mutating func addInputs(_ ins: [String]) {
            inputs = ins
        }
        
        func isInOriginalState() -> Bool {
            return state == .off
        }
    }
    
    struct Conj : Mod {
        let type: Character = "&"
        let outputs: [String]
        var hist: [String:Signal] = [:]
        var description: String {
            "\(hist.keys) \(type) \(outputs)"
        }
        
        init(outputs: [String]) {
            self.outputs = outputs
        }
        mutating func apply(from: String, signal: Day20.Signal) -> Day20.Signal? {
            hist[from] = signal
            let allHigh: Bool = hist.values.allSatisfy { sig in
                sig == .high
            }
            return allHigh ? .low : .high
        }
        
        mutating func addInputs(_ ins: [String]) {
            ins.forEach { hist[$0] = .low }
        }
        
        func isInOriginalState() -> Bool {
            return hist.values.allSatisfy { $0 == .low }
        }
        
    }
    

}

private protocol Mod: CustomStringConvertible {
    var type: Character { get }
    var outputs: [String] { get }
    var description: String { get }
    mutating func apply(from: String, signal: Day20.Signal) -> Day20.Signal?
    mutating func addInputs(_ ins: [String])
    func isInOriginalState() -> Bool
}

private extension Mod {
    public var description: String {
        " -> \(outputs)"
    }
}
