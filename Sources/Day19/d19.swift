import Foundation

private extension Array{
    func slices(by cond: (Element)->Bool) -> [[Element]] {
        var s: [Element] = []
        var result: [[Element]] = []
        for item in self {
            if cond(item) {
                result.append(s)
                s.removeAll()
            } else {
                s.append(item)
            }
        }
        if !s.isEmpty {
            result.append(s)
        }
        return result
    }
}

func parseRatings(_ ratings: some StringProtocol) -> [String:Int] {
    var rateDict: [String:Int] = [:]
    let ratings = ratings.trimmingCharacters(in: ["{","}"])
    for expr in ratings.split(separator: ",") {
        let kv = expr.split(separator: "=")
        rateDict[String(kv[0])] = Int(kv[1])
    }
    return rateDict
}

func parseWorkflows(_ wf: some StringProtocol) -> (String, [(String,String)]){
    var wfDict: [(String,String)] = []
    let nameWork = wf.trimmingCharacters(in: ["}"]).split(separator: "{")
    let name = String(nameWork[0])
    for x in nameWork[1].split(separator: ",") {
        let kv = x.split(separator: ":").map { String($0) }
        if kv.count > 1 {
            wfDict.append((kv[0], kv[1]))
        } else {
            wfDict.append(("else", kv[0]))
        }
    }
    return (name, wfDict)
}

func eval(pred: String, with: [String:Int]) -> Bool {
    let mathPred = NSPredicate(format: pred, argumentArray: [])
    let predVal = mathPred.evaluate(with: with)
    return predVal
}

struct Day19 {
    let filename = "/Users/mehrdad/workspace/swift_projects/AoC23/Day19/input.txt"
    let lines: [String.SubSequence]
    
    init() {
        let contents = readfile(filename)
        lines = contents.split(omittingEmptySubsequences: false) { $0.isNewline }
    }
    
    init(input: String) {
        let contents = input
        lines = contents.split(omittingEmptySubsequences: false) { $0.isNewline }
    }
    
    func partOne() -> Int {
        let slices = lines.slices() { $0.isEmpty }
        let m = WFMachine(workflows: slices[0], ratings: slices[1])
        return m.partOne()
    }
    
    func partTwo() -> Int {
        let slices = lines.slices() { $0.isEmpty }
        let m = WFMachine(workflows: slices[0], ratings: slices[1])
        return m.partTwo()
    }
    
    struct RatingsBox {
        let box: [String: ClosedRange<Int>]
        
        init(_ rtR: [String : ClosedRange<Int>]) {
            self.box = rtR
        }
        
        init() {
            self.box = ["x": 0...4001,
                        "m": 0...4001,
                        "a": 0...4001,
                        "s": 0...4001]
        }
        
        func volume() -> Int {
            return self.box.values.map {
                $0.upperBound - $0.lowerBound - 1
            }.reduce(1, *)
        }
        
        func _and(_ key: String, _ op: String, _ val: Int) -> Self? {
            switch op {
            case "<":
                if self.box[key]!.upperBound <= val {return self}
                if val - self.box[key]!.lowerBound <= 1 {return nil}
                var newRt = self.box
                newRt[key]! = newRt[key]!.lowerBound...val
                return RatingsBox(newRt)
            case ">":
                if self.box[key]!.lowerBound >= val {return self}
                if self.box[key]!.upperBound - val <= 1 {return nil}
                var newRt = self.box
                newRt[key]! = val...newRt[key]!.upperBound
                return RatingsBox(newRt)
            default:
                fatalError("unknown predicate")
            }
        }
        
        func and(_ pred: String) -> Self? {
            if pred == "else" {return self}
            let (key, op, val) = _parsePred(pred)
            return _and(key,op,val)
        }
        
        func andNot(_ pred: String) -> Self? {
            if pred == "else" {return nil}
            var (key, op, val) = _parsePred(pred)
            
            // apply not operation
            switch op {
            case "<":
                op = ">"
                val = val-1
            case ">":
                op = "<"
                val = val+1
            default:
                fatalError("unknown predicate")
            }
            
            return _and(key,op,val)
        }
        
        func _parsePred(_ pred: String) -> (String, String, Int) {
            var sepi: String.Index
            let op: String
            if let i = pred.firstIndex(of: "<") {
                sepi = i
                op = "<"
            } else {
                sepi = pred.firstIndex(of: ">")!
                op = ">"
            }
            let (key, value) = (pred.prefix(upTo: sepi),Int(pred.suffix(from: pred.index(after: sepi)))!)
            return (String(key),String(op),value)
        }
    }

    struct WFMachine {
        var wf: [String: [(String, String)]] = [:]
        var rt: [[String:Int]] = []
        
        init(workflows: [some StringProtocol], ratings: [some StringProtocol]) {
            for line in workflows {
                let (name, wfDict) = parseWorkflows(line)
                self.wf[name] = wfDict
            }
            for line in ratings {
                self.rt.append(parseRatings(line))
            }
        }
        
        func runWorkflow(_ key: String, on rt: [String:Int]) -> String{
            let rates = rt
            for p in self.wf[key]! {
                if p.0 == "else" { return p.1 }
                if eval(pred: p.0, with: rates) {
                    return p.1
                }
            }
            fatalError("never")
        }
        
        func partOne() -> Int {
            var ans = 0
            for rate in rt {
                var state = runWorkflow("in", on: rate)
                while state != "A" && state != "R" {
                    state = runWorkflow(state, on: rate)
                }
                if state == "A" {
                    ans += rate.values.reduce(0, +)
                }
            }
            return (ans)
        }
        
        func ngbrs(wfName: String, rBox: RatingsBox) -> [(String, RatingsBox)] {
            var runningBox: RatingsBox? = rBox
            var result: [(String, RatingsBox)] = []
            for (pred, act) in self.wf[wfName]! {
                if let newBox = runningBox!.and(pred) {
                    result.append((act, newBox))
                }
                runningBox = runningBox!.andNot(pred)
                if runningBox == nil { break }
            }
            return result
        }
        
        func partTwo() -> Int {
            // dfs
            var ans: [RatingsBox] = []
            var stack = [("in",RatingsBox())] // workflow, ratingBox
            while !stack.isEmpty {
                let (x,y) = stack.popLast()!
                if x == "A" { ans.append(y) ;continue }
                if x == "R" { continue }
                for (w,r) in ngbrs(wfName: x, rBox: y) {
                    stack.append((w,r))
                }
            }
            let res = ans.map { $0.volume() }
                .reduce(0, +)
            return (res)
        }
    }

}
