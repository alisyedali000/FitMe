//
//  DateManager.swift
//  Koy
//
//  Created by Taimoor Arif on 10/10/2023.
//

import Foundation

class DateManager {
    
    static let shared = DateManager()
    
    func getString(from date: Date) -> String {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let stringDate = dateFormat.string(from: date)
        return stringDate
    }
    
    func getDobString(from string: String) -> String {
        
        let date = stringToDate(from: string)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let newDate = dateFormatter.string(from: date)
        
        return newDate
    }
    
    func getDobString(from date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let newDate = dateFormatter.string(from: date)
        
        return newDate
    }
    
    func stringToDate(from string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let date = formatter.date(from: string) ?? Date()
        return date
    }
    
    func getYears(date: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let dateOfBirth = dateFormatter.date(from: date) {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.year], from: dateOfBirth, to: Date())
            
            if let years = dateComponents.year, years > 0 {
//                return "\(years) Year\(years > 1 ? "s" : "")"
                return years
            }
        }
        return 0
    }

    
    func getMessageKey(from str: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: str) ?? Date()

        let outformatter = DateFormatter()
        outformatter.dateFormat = "yyyy-MM-dd"
        return outformatter.string(from: date)
    }
    
    func timeInAmPm(from str: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: str) ?? Date()

        let outformatter = DateFormatter()
        outformatter.dateFormat = "h:mm a"
        return outformatter.string(from: date)
    }
}

extension DateManager {
    
    func chatListTimeAgo(from strDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: strDate) ?? Date()
        
        let currentDate = Date()
        
        let timeInterval = currentDate.timeIntervalSince(date)
        
        return getTotalTimeAgo(from: timeInterval, unitStyle: .full)
    }
    
    func timeAgo(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()

        let components = calendar.dateComponents([.second, .minute, .hour, .day, .weekOfYear], from: date, to: now)

        if let week = components.weekOfYear, week > 0 {
            return "\(week) week\(week == 1 ? "" : "s") ago"
        } else if let day = components.day, day > 0 {
            return "\(day) day\(day == 1 ? "" : "s") ago"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour) hour\(hour == 1 ? "" : "s") ago"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute) minute\(minute == 1 ? "" : "s") ago"
        } else if let second = components.second, second > 0 {
            return "\(second) second\(second == 1 ? "" : "s") ago"
        } else {
            return "Just now"
        }
    }
    
    func getTotalTimeAgo(from date: TimeInterval, unitStyle: DateComponentsFormatter.UnitsStyle) -> String {
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute, .second]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = unitStyle
        guard let timeAgo = formatter.string(from: date) else {
            debugPrint("Failed to calculate time ago")
            return ""
        }
        
        return unitStyle == .full ? "\(timeAgo) ago" : "\(timeAgo)"
    }
    
    func getLastSeen(from time: String, timeZone: String) -> String {
        
        let myTimeZonedTime = getTimeZonedDate(from: time, timeZoneId: timeZone)
        let messageKey = self.getMessageKey(from: myTimeZonedTime)
        let day = getGroupedMsgDate(from: messageKey)
        let time = timeInAmPm(from: myTimeZonedTime)
        
        return "\(day) \(time)"
    }
    
    func getGroupedMsgDate(from string: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: string) {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let _ = calendar.date(byAdding: .day, value: -1, to: today)!
            
            if calendar.isDateInToday(date) {
                
                return "Today"
            } else if calendar.isDateInYesterday(date) {
                
                return "Yesterday"
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM d, yyyy" // Change the format as needed
                let formattedDate = formatter.string(from: date)
                return formattedDate
            }
        }
        
        debugPrint("Invalid date string")
        return ""
    }
    
    func getTimeZonedDate(from date: String, timeZoneId: String) -> String {
        
        let currentTimeZone = TimeZone.current.identifier
        
        if currentTimeZone != timeZoneId {
            
            let otherTimeZoneFormatter = DateFormatter()
            otherTimeZoneFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            otherTimeZoneFormatter.timeZone = TimeZone(identifier: timeZoneId)
            
            let otherZoneTime = otherTimeZoneFormatter.date(from: date) ?? Date()
            
            let localFormat = DateFormatter()
            localFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            localFormat.timeZone = TimeZone.current
            let localTime = localFormat.string(from: otherZoneTime)
            
            return localTime
        }
        
        return date
    }
    
    func utcToLocal(dateStr: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
            return dateFormatter.string(from: date)
        }
        
        return ""
    }
    
    func notificationTimeAgo(from strDate: String) -> String {
        
        let localTime = self.utcToLocal(dateStr: strDate)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: localTime) ?? Date()
        
        let currentDate = Date()
        
        let timeInterval = currentDate.timeIntervalSince(date)
        
        return getTotalTimeAgo(from: timeInterval, unitStyle: .abbreviated)
    }
}

// MARK: Date range operation
extension DateManager {
    
    func getCurrentWeekStartEndDate() -> (startDate: String, endDate: String) {
        let currentWeekStartDate = DateManager.shared.getLastMonday()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"

        let endDateCalander = Calendar.current.date(byAdding: .day, value: 6, to: currentWeekStartDate)!
        let startDate = dateFormatter.string(from: currentWeekStartDate)
        let endDate = dateFormatter.string(from: endDateCalander)
        
        return(startDate, endDate)
        
    }
    
    func convertDateFormat(inputDateString: String, inputFormat: String, outputFormat: String) -> String? {
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = inputFormat
        guard let inputDate = dateFormatterInput.date(from: inputDateString) else {
            return nil // Return nil if the input date string is not in the expected format
        }

        let dateFormatterOutput = DateFormatter()
        dateFormatterOutput.dateFormat = outputFormat
        let outputDateString = dateFormatterOutput.string(from: inputDate)

        return outputDateString
    }

    
     func getLastMonday() -> Date {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Set Monday as the first day of the week
        
        let today = Date()
        let components = calendar.dateComponents([.weekday], from: today)
        
        // Calculate the number of days to subtract to get to the last Monday
        let daysToSubtract = (components.weekday! + 5) % 7
        
        // Subtract the days to get the last Monday
        let lastMonday = calendar.date(byAdding: .day, value: -daysToSubtract, to: today)!
        
        return lastMonday
    }
}
