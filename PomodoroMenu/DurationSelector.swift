//
//  DurationSelector.swift
//  PomodoroMenu
//
//  Created by Alex Ryan on 9/19/24.
//

import SwiftUI

//struct DurationSelector: View {
//    @Binding var selectedDuration: Int
//    let durations: [Int]
//    let setDuration: (Int) -> Void  // Function to set the duration
//
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: true) {
//            HStack {
//                ForEach(durations, id: \.self) { duration in
//                    Button(action: {
//                        setDuration(duration)
//                    }) {
//                        Text(durationText(for: duration))
//                            .padding(8)
//                            .frame(minWidth: 50)
//                            .background(selectedDuration == duration ? Color.blue.opacity(0.3) : Color.gray.opacity(0.1))
//                            .cornerRadius(5)
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    .contentShape(Rectangle())
//                }
//            }
//            .padding(.bottom, 4)
//        }
//    }
//
//    private func durationText(for duration: Int) -> String {
//        if duration >= 60 {
//            let minutes = duration / 60
//            return "\(minutes) min"
//        } else {
//            return "\(duration) sec"
//        }
//    }
//}
/// `DurationSelector` is a view that presents a horizontal list of duration options.
/// Users can select a duration, which updates the bound property accordingly.
struct DurationSelector: View {
        /// Binding to the selected duration in seconds.
    @Binding var selectedDuration: Int

        /// Array of available durations in seconds.
    let durations: [Int]

        /// Closure to set the selected duration.
    let setDuration: (Int) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 10) {
                ForEach(durations, id: \.self) { duration in
                    Button(action: {
                        setDuration(duration)
                    }) {
                        Text(durationText(for: duration))
                            .padding(8)
                            .frame(minWidth: 50)
                            .background(selectedDuration == duration ? Color.blue.opacity(0.3) : Color.gray.opacity(0.1))
                            .cornerRadius(5)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .contentShape(Rectangle())
                }
            }
            .padding(.vertical, 5)
        }
    }

        /// Formats the duration into a user-friendly string.
        /// - Parameter duration: Duration in seconds.
        /// - Returns: Formatted string (e.g., "10 sec", "1 min").
    private func durationText(for duration: Int) -> String {
        if duration >= 60 {
            let minutes = duration / 60
            return "\(minutes) min"
        } else {
            return "\(duration) sec"
        }
    }
}

    // MARK: - Preview

struct DurationSelector_Previews: PreviewProvider {
    static var previews: some View {
        DurationSelector(
            selectedDuration: .constant(60),
            durations: TimerModel.predefinedDurations,
            setDuration: { _ in }
        )
        .previewLayout(.sizeThatFits)
    }
}
