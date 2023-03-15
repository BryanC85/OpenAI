//
//  OpenAIUtility.swift
//  OpenAI
//
//  Created by Quakly on 3/15/23.
//


import Foundation



extension URLRequest {
    mutating func setJSONContentType() {
        setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}

extension Encodable {
    func toJSONData() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
}

extension Data {
    func decodeJSON<T: Decodable>(type: T.Type, decoder: JSONDecoder = JSONDecoder()) throws -> T {
        return try decoder.decode(type, from: self)
    }
}

extension FileManager {
    func readTextFile(atPath path: String) throws -> String {
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        return String(data: data, encoding: .utf8)!
    }
    
    func writeTextFile(atPath path: String, content: String) throws {
        try content.write(to: URL(fileURLWithPath: path), atomically: true, encoding: .utf8)
    }
}

extension String {
    func urlEncoded() -> String {
        let allowedCharacterSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
    }
    
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? self
    }
    
    func sanitizedForAPI() -> String {
        var sanitized = self
        sanitized = sanitized.replacingOccurrences(of: "\"", with: "\\\"")
        sanitized = sanitized.replacingOccurrences(of: "\n", with: " ")
        return sanitized
    }
}

extension Array where Element == Double {
    func average() -> Double {
        return self.reduce(0.0, +) / Double(self.count)
    }
    
    func sum() -> Double {
        return self.reduce(0.0, +)
    }
}

extension Int {
    static func random(in range: Range<Int>) -> Int {
        let count = UInt32(range.upperBound - range.lowerBound)
        return Int(arc4random_uniform(count)) + range.lowerBound
    }
}

extension Double {
    func metersToFeet() -> Double {
        return self * 3.28084
    }
    
    func kilogramsToPounds() -> Double {
        return self * 2.20462
    }
    
    func asCurrencyString(locale: Locale = .current) -> String? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .currency
        return formatter.string(from: self as NSNumber)
    }
}

extension String {
    func asMeters() -> Double? {
        return Double(self)
    }
    
    func asKilograms() -> Double? {
        return Double(self)
    }
    
    func asCurrencyDouble(locale: Locale = .current) -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .currency
        return formatter.number(from: self)?.doubleValue
    }
    
    func matches(for regex: String) -> Result<[String], Error> {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            let matches = results.map {
                String(self[Range($0.range, in: self)!])
            }
            return .success(matches)
        } catch let error {
            return .failure(error)
        }
    }
}
extension String {
    func replacingMatches(for regex: String, with template: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let range = NSRange(self.startIndex..., in: self)
            return regex.stringByReplacingMatches(in: self, range: range, withTemplate: template)
        } catch let error {
            print("Invalid regex: \(error.localizedDescription)")
            return self
        }
    }
    
    func truncate(to length: Int, suffix: String = "...") -> String {
        if self.count > length {
            return String(self.prefix(length)) + suffix
        } else {
            return self
        }
    }
    
    func removingPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) {
            return String(self.dropFirst(prefix.count))
        } else {
            return self
        }
    }
    
    func removingSuffix(_ suffix: String) -> String {
        if self.hasSuffix(suffix) {
            return String(self.dropLast(suffix.count))
        } else {
            return self
        }
    }
}

extension Array {
    func randomElement() -> Element? {
        if self.isEmpty {
            return nil
        } else {
            let index = Int.random(in: 0..<self.count)
            return self[index]
        }
    }
    
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}

extension Date {
    func adding(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hours, to: self)!
    }
    
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func adding(seconds: Int) -> Date {
        return Calendar.current.date(byAdding: .second, value: seconds, to: self)!
    }
}

extension TimeInterval {
    func inWords() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.includesApproximationPhrase = true
        formatter.includesTimeRemainingPhrase = true
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        return formatter.string(from: self)!
    }
}

extension NotificationCenter {
    func addObserver(forName name: Notification.Name?, object obj: Any?, queue: OperationQueue?, using block: @escaping (Notification) -> Void) -> NSObjectProtocol {
        return addObserver(forName: name, object: obj, queue: queue, using: block)
    }
}

