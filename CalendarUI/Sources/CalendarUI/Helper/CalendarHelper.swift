

import Foundation

struct CalendarHelper {
    static func getCalendarGrid(for date: Date) -> [[Date?]] {
        // Create a calendar instance using the current calendar settings.
        var calendar = Calendar.current
        calendar.firstWeekday = 1 // Set Sunday as the first day of the week.

        // Determine the first day of the month based on the given date.
        let dateComponents = calendar.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = calendar.date(from: dateComponents)!

        // Determine the range and count of days in the month.
        let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!
        let numberOfDaysInMonth = range.count

        // Determine the weekday index of the first day of the month.

        let weekdayOfFirstDay = calendar.component(.weekday, from: firstDayOfMonth) - 1

        // Initialize variables to store the grid of dates.
        var daysInGrid = [[Date?]]()
        var currentRow = [Date?]()

        // Iterate over the days of the month to populate the grid.
        for day in 0 ..< (numberOfDaysInMonth + weekdayOfFirstDay) {
            if day < weekdayOfFirstDay {
                currentRow.append(nil)
            } else {
                let dateToAdd = calendar.date(byAdding: .day, value: day - weekdayOfFirstDay, to: firstDayOfMonth)!
                currentRow.append(dateToAdd)
            }

            // If a complete row (7 days) has been filled, add it to the grid and reset the row.

            if currentRow.count == 7 {
                daysInGrid.append(currentRow)
                currentRow = [Date?]()
            }
        }

        // If the last row is not complete, add it to the grid.
        if !currentRow.isEmpty {
            daysInGrid.append(currentRow)
        }

        return daysInGrid
    }
}
