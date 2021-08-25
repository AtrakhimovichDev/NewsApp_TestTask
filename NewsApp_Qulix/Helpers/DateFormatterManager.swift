//
//  DateFormatterManager.swift
//  NewsApp_Qulix
//
//  Created by Andrei Atrakhimovich on 25.08.21.
//

import Foundation

class DateFormatterManager {
    static var shared = DateFormatterManager()

    func getDateFromString(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: string) {
            return date
        } else {
            return Date()
        }
    }

    func getStringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
}
