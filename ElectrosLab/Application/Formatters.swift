

//
//  Formatters.swift
//
//  Created by Ibrahim on 4/26/17.
//  Copyright © 2017 Ibrahim Kteish. All rights reserved.
//

import Foundation
/// class holds date object along with a value of any type
final class DateValueHolder {
    
    let date: Date
    var value: Any?
    
    init(date: Date, value:Any?) {
        self.date = date
        self.value = value
    }
}
//Make DateValueHolder conforms to Equatable
extension DateValueHolder : Equatable {}
func == (lhs: DateValueHolder, rhs: DateValueHolder) -> Bool { return lhs.date == rhs.date }

extension Date {
    /// convert date time to user's phone timeZone
    func toLocalTime() -> Date {
        
        let tz: TimeZone = TimeZone.current
        let seconds = tz.secondsFromGMT(for: self)
        return Date(timeInterval: Double( seconds ), since: self)
    }
}
///Instances of NSDateFormatter create string representations of NSDate objects, and convert textual representations of dates and times into NSDate objects. For user-visible representations of dates and times, NSDateFormatter provides a variety of localized presets and configuration options. For fixed format representations of dates and times, you can specify a custom format string.
fileprivate let trellisDateFormatter = DateFormatter()
///class handles trellis date formating
final class TrellisDateFormatter {
    ///Create a formatted date string from string using the provided format style
    ///
    /// - Parameter date: string represents a date
    /// - Parameter format: String represents the date format by default `dd/mm/yy`
    /// - Returns: formated date string
    static func formatDate(_ date: String, to format: String = "dd/mm/yy") -> String {
        
        trellisDateFormatter.dateFormat = "yyyy-mm-dd"
        
        if let date = trellisDateFormatter.date(from: date) {
            
            trellisDateFormatter.dateFormat = format
            
            let formatted = trellisDateFormatter.string(from: date)
            
            return formatted
        }
        
        return date
    }
    ///Create a formatted date string from Date object using the provided format style
    ///
    /// - Parameter date: A date object
    /// - Parameter format: String represents the date format by default `yyyy-MM-dd`
    /// - Returns: Formated date string
    static func formatDate(_ date: Date, to format: String = "yyyy-MM-dd") -> String {
        
        trellisDateFormatter.dateFormat = format
        
        let formatted = trellisDateFormatter.string(from: date)
        
        return formatted
        
    }
    ///Create a date object from string
    ///
    /// - Parameter date: string represents a date using "yyyy-MM-dd" format
    /// - Parameter format: String represents the date format by default `yyyy-MM-dd`
    /// - Returns: otional date object
    static func dateFromString(_ date: String) -> Date? {
        
        trellisDateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = trellisDateFormatter.date(from: date) {
            
            let _date = date.toLocalTime()
            return _date
        }
        
        return nil
    }
    ///Generate array of `DateValueHolder` objects between 2 dates
    ///
    /// - Parameter startDate: string represents a date using "yyyy-mm-dd" format
    /// - Parameter endDate: string represents a date using "yyyy-mm-dd" format
    /// - Returns: array of `DateValueHolder` object between startDate and endDate
    static func generateDates(between startDate: Date, and endDate: Date) -> [DateValueHolder] {
        
        // Formatter for printing the date, adjust it according to your needs:
        trellisDateFormatter.dateFormat = "yyyy-mm-dd"
        let calendar = Calendar.current
        var dates: [DateValueHolder] = []
        var startDate = startDate
        while startDate <= endDate {
            let v : Any? = nil
            dates.append(DateValueHolder(date: startDate, value: v))
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        }
        return dates
    }
    /// Make `[DateValueHolder]` generator
    ///
    /// - Parameter days: number of days should always be negative value
    /// - Returns: a function that takes a end date and return an array of `[DateValueHolder]` starting from the endDate by adding the days param as start date
    static func generate(_ days: Int) -> (Date) -> [DateValueHolder] {
        return { endDate in
            let startDate = Calendar.current.date(byAdding: .day, value: days, to: endDate)!
            return TrellisDateFormatter.generateDates(between: startDate, and: endDate)
        }
    }
}

/// Enum holds the different types of formatting.
enum NumberFormatType {
    case percentage
    case scores
    case numbers
    case fractionedNumbers
}
/// protocol to be implemented by any concret class/strut to provide numberformatting settings
protocol NumberSettings {
    /// represents how many fraction after the point
    var fraction: Int { get }
    ///represents the sufficx after a number like k,m or empty.
    var positiveSuffix: String { get }
}
/// Enum holds the different type of trellis number representation.
enum NumberRepresentation: NumberSettings {
    
    case lessThanOneThousand
    case lessThanOneMillion
    case aboveMillion
    
    init(rawValue: Int) {
        
        if rawValue <= 1 {
            self = .lessThanOneThousand
        } else if rawValue <= 2 {
            self = .lessThanOneMillion
        } else {
            self = .aboveMillion
        }
    }
    
    var fraction: Int {
        
        switch self {
        case .aboveMillion:
            return 2
        case .lessThanOneMillion:
            return 1
        case .lessThanOneThousand:
            return 0
        }
    }
    
    var positiveSuffix: String {
        
        switch self {
        case .aboveMillion:
            return "m"
        case .lessThanOneMillion:
            return "k"
        case .lessThanOneThousand:
            return ""
        }
    }
}
/// extend NumberFormatter to apply our settings
extension NumberFormatter {
    /// Apply our settong to a number formatter instance
    ///
    /// - Parameter settings: An object that conforms to NumberSettings protocol
    func apply(settings type: NumberSettings) {
        self.positiveSuffix = type.positiveSuffix
        self.maximumFractionDigits = type.fraction
        self.minimumFractionDigits = 0
    }
}
/// struct holds a cached object of type NumberFormatter
struct NumberFormatterCache {
    static let numberFormatter: NumberFormatter = {
        var numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US")
        numberFormatter.roundingMode = .halfUp
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.multiplier = 1
        numberFormatter.alwaysShowsDecimalSeparator = true
        return numberFormatter
    }()
}
/// struct responsible for Trellis number format accross all the native part of the app.
struct TrellisNumberFormatter {
    
    typealias Abbrevation = (threshold: Double, divisor: Double, representationIndex: Int)
    
    /// format the any number type other that scores, percentage and fractioned numbers.
    ///the rules are set in a confluence doc.
    /// - Parameter originalValue: a double value.
    /// - Returns: formated string
    static func formatUsingAbbrevation (for originalValue: Double) -> String {
        
        let numberFormatter = NumberFormatterCache.numberFormatter
        let abbreviations: [Abbrevation] = [(0, 1, 1),
                                            (1000.0, 1000.0, 2),
                                            (1_000_000.0, 1_000_000.0, 3),
                                            (1_000_000_000.0, 1_000_000.0, 4)]
        
        let startValue = originalValue
        
        let abbreviation: Abbrevation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations {
                if startValue < tmpAbbreviation.threshold {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        } ()
        let indexOfAbb = abbreviation.representationIndex
        let representation = NumberRepresentation(rawValue: indexOfAbb)
        
        let value = originalValue / abbreviation.divisor
        numberFormatter.apply(settings: representation)
        return numberFormatter.string(from: NSNumber (value:value)) ?? "\(value)"
    }
    
    /// format the 4 number types we have in the trellis app.
    ///the rules are set in a confluence doc.
    /// - Parameter number: a double value.
    /// - Parameter type: value from NumberFormatType.
    /// - Returns: formated string
    static func format(_ number: Double, for type: NumberFormatType) -> String {
        
        let ns_number = NSNumber(value: number)
        let numberFormatter = NumberFormatterCache.numberFormatter
        
        switch type {
        case .scores:
            numberFormatter.numberStyle = .decimal
            numberFormatter.positiveSuffix = ""
            numberFormatter.alwaysShowsDecimalSeparator = true
            numberFormatter.minimumFractionDigits = 1
            numberFormatter.maximumFractionDigits = 1
        case .fractionedNumbers:
            if number < 10 {
                numberFormatter.positiveSuffix = ""
                numberFormatter.alwaysShowsDecimalSeparator = true
                numberFormatter.minimumFractionDigits = 1
                numberFormatter.maximumFractionDigits = 1
            } else {
                return TrellisNumberFormatter.format(number, for: .numbers)
            }
        case .percentage:
            numberFormatter.numberStyle = .percent
            numberFormatter.positiveSuffix = "%"
            numberFormatter.alwaysShowsDecimalSeparator = false
            numberFormatter.maximumFractionDigits = 0
            numberFormatter.minimumFractionDigits = 0
        case .numbers:
            numberFormatter.positiveSuffix = ""
            numberFormatter.numberStyle = .decimal
            numberFormatter.alwaysShowsDecimalSeparator = false
            return formatUsingAbbrevation(for: number)
        }
        
        guard let formatted = numberFormatter.string(from: ns_number) else {
            return "\(number)"
        }
        
        return formatted
    }
    
    //Helpers
    static func formatScore(_ number: Double) -> String {
        return TrellisNumberFormatter.format(number, for: .scores)
    }
    
    static func formatNumber(_ number: Double) -> String {
        return TrellisNumberFormatter.format(number, for: .numbers)
    }
    
    static func formatPercentage(_ number: Double) -> String {
        return TrellisNumberFormatter.format(number, for: .percentage)
    }
    
    static func formatFractionedNumber(_ number: Double) -> String {
        return TrellisNumberFormatter.format(number, for: .fractionedNumbers)
    }
    /// convert formated string to Double. ie 1.2k to 12000
    ///
    /// - Parameter string: A Formatted string value
    /// - Returns: Optional Double value
    static func unformat(string number: String) -> Double? {
        
        var number = number
        let percent = number.substring(from: number.index(number.endIndex, offsetBy:-1))
        if percent == "%" {
            number = number.substring(to: number.index(number.endIndex, offsetBy:-1))
        }
        ///A regular expressin to check our formatted number style
        /// [one or more digit] - [optiona(.)] - [one or more digit] - [optional(k or m or b)]
        let regexp = "^[\\d]+\\.?[\\d]*?[k|m|b]?$"
        
        if number.range(of:regexp, options: .regularExpression) == nil {
            return nil
        }
        
        if let number = Double(number) {
            return number
        }
        
        guard let numberOnly = Double(String(number.filter { "1234567890.".contains(String($0)) })) else {
            return nil
        }
        let abbrv = number.substring(from: number.index(number.endIndex, offsetBy:-1))
        
        if abbrv == "k" {
            return numberOnly * 1_000
        }
        
        if abbrv == "m" {
            return numberOnly * 1_000_000
        }
        
        if abbrv == "b" {
            return numberOnly * 1_000_000_000
        }
        
        return nil
    }
}
