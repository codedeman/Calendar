// The Swift Programming Language

import SwiftUI

public struct CalendarCustomizeViewBasic: View {

    //MARK: Property
    @Binding public var selectedEndDate: Date?
    @Binding public var selectedStartDate: Date?
    private var colorSelected: Color
    private var colorUnSelected: Color
    private var config: CalendarCustomizeConfig

    public init(
        selectedDate: Binding<Date?>,
        selectedEndDate: Binding<Date?>,
        colorSelected: Color = .blue,
        colorUnSelected: Color = .clear,
        config: CalendarCustomizeConfig = .init(
            width: 50,
            height: 60,
            calendarType: .normal
        )
    ) {
        self.colorSelected = colorSelected
        self.colorUnSelected = colorUnSelected
        self._selectedStartDate = selectedDate
        self._selectedEndDate = selectedEndDate
        self.config = config
    }

    public var body: some View {
            VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Spacer()
                Button(action: {
                    selectedStartDate = Calendar.current.date(
                        byAdding: .month,
                        value: -1,
                        to: selectedStartDate ?? Date()
                    )
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                }
                Text(selectedStartDate.map {
                    DateFormatter().monthSymbols[
                        Calendar.current.component(
                            .month,
                            from: $0
                        ) - 1] + " " + String(
                        Calendar.current.component(.year, from: $0)
                    )
                } ?? "")
                    .font(.title2)
                    .fontWeight(.bold)
                Button(action: {
                    selectedStartDate = Calendar.current.date(
                        byAdding: .month,
                        value: 1,
                        to: selectedStartDate ?? Date()
                    )
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                Spacer()

            }.padding(.top)

                LazyVGrid(
                    columns: Array(
                        repeating: GridItem(.flexible()),
                        count: 7
                    )
                ) {
                ForEach(CalendarCustomizeHelper.getCalendarGrid(for: selectedStartDate ?? Date()), id: \.self) { row in
                    ForEach(row, id: \.self) { date in
                        if let date = date {
                            let isSelected: Bool = {
                                if let startDate = selectedStartDate, let endDate = selectedEndDate {
                                    return Calendar.current.isDate(date, inSameDayAs: startDate) ||
                                    Calendar.current.isDate(
                                        date,
                                        inSameDayAs: endDate
                                    )
                                } else {
                                    return Calendar.current.isDate(
                                        date,
                                        inSameDayAs: selectedStartDate ?? Date()
                                    )
                                }
                            }()


                            let isInRange = (
                                selectedStartDate != nil && selectedEndDate != nil
                            ) && (
                                date  >= selectedStartDate! && date <= selectedEndDate!
                            )

                            Text(
                                Calendar.current.isDate(
                                    date,
                                    inSameDayAs: Date()
                                ) ? "Today" : String(
                                    Calendar.current.component(
                                        .day,
                                        from: date
                                    )
                                )
                            )
                            .frame(
                                width: config.width,
                                height: config.height
                            )
                            .foregroundColor(
                                isSelected ? .white :. black
                            )
                            .background(
                                isSelected ? colorSelected : (isInRange ? colorSelected.opacity(0.3) : colorUnSelected)
                            )
                            .cornerRadius(config.cornerRadius)
                            .onTapGesture {
                                if config.calendarType == .normal {
                                    selectedStartDate = date
                                    selectedEndDate = date
                                } else {
                                    if selectedStartDate == nil {
                                        selectedStartDate = date
                                        selectedEndDate = nil
                                    } else if selectedEndDate == nil {
                                        if date < selectedStartDate ?? Date() {
                                            selectedEndDate = nil
                                            selectedStartDate = date
                                        } else {
                                            selectedEndDate = date
                                        }
                                    } else {
                                        if date < selectedStartDate ?? Date() {
                                            selectedStartDate = date
                                            selectedEndDate = nil
                                        } else if date > selectedEndDate ?? Date() {
                                            selectedEndDate = date
                                        } else {
                                            selectedStartDate = date
                                            selectedEndDate = nil
                                        }
                                    }
                                }
                            }

                        } else {
                            Text("")
                                .frame(
                                    maxWidth: .infinity
                                )
                        }
                    }
                }.frame(maxHeight: .infinity)
            }
            Spacer()
        }

    }
}

struct CalendarView_Previews: PreviewProvider {
    @State static var selectedStartDate: Date? = Date()
    @State static var selectedEndDate: Date?

    static var previews: some View {
        CalendarCustomizeViewBasic(
            selectedDate: $selectedStartDate,
            selectedEndDate: $selectedEndDate
        )
    }
}
