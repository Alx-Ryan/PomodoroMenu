//
//  SettingsView.swift
//  PomodoroMenu
//
//  Created by Alex Ryan on 9/16/24.
//

    //
    //  SettingsView.swift
    //  PomodoroMenu
    //

import SwiftUI

    /// `SettingsView` allows users to configure the Pomodoro timer settings,
    /// including notification preferences, duration selections, sound choices,
    /// and cycle counts before a long rest.
struct SettingsView: View {
        // MARK: - Observed Objects

        /// The `TimerModel` instance managing the timer's state and behavior.
    @ObservedObject var timerModel: TimerModel

        // MARK: - Constants

        /// Available notification sounds.
    let availableSounds: [String] = ["Default", "Beep"]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
                // MARK: - Notification Settings

                /// Toggle for enabling or disabling notifications.
            Toggle("Enable Notifications", isOn: $timerModel.notificationsEnabled)
                .padding(.bottom, 10)

                /// Picker for selecting the notification sound.
            VStack(alignment: .leading, spacing: 5) {
                Text("Notification Sound:")
                    .font(.headline)
                Picker("Select Sound", selection: $timerModel.selectedSoundName) {
                    ForEach(availableSounds, id: \.self) { sound in
                        Text(sound == "Default" ? "System Default" : sound)
                            .tag(sound)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding(.bottom, 10)

                // MARK: - Durations Settings

                /// Work Duration Selector
            VStack(alignment: .leading, spacing: 5) {
                Text("Work Duration:")
                    .font(.headline)
                DurationSelector(
                    selectedDuration: $timerModel.workDuration,
                    durations: TimerModel.predefinedDurations,
                    setDuration: timerModel.setWorkDuration
                )
            }
            .padding(.bottom, 10)

                /// Rest Duration Selector
            VStack(alignment: .leading, spacing: 5) {
                Text("Rest Duration:")
                    .font(.headline)
                DurationSelector(
                    selectedDuration: $timerModel.restDuration,
                    durations: TimerModel.predefinedDurations,
                    setDuration: timerModel.setRestDuration
                )
            }
            .padding(.bottom, 10)

                /// Long Rest Duration Selector
            VStack(alignment: .leading, spacing: 5) {
                Text("Long Rest Duration:")
                    .font(.headline)
                DurationSelector(
                    selectedDuration: $timerModel.longRestDuration,
                    durations: TimerModel.predefinedDurations,
                    setDuration: timerModel.setLongRestDuration
                )
            }
            .padding(.bottom, 10)

                // MARK: - Cycles Before Long Rest

                /// Picker for setting the number of work cycles before a long rest.
            VStack(alignment: .leading, spacing: 5) {
                Text("Cycles Before Long Rest:")
                    .font(.headline)
                Picker("Cycles", selection: $timerModel.cyclesBeforeLongRest) {
                    ForEach(1..<10) { cycle in
                        Text("\(cycle)").tag(cycle)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 100)
            }

            Spacer()
        }
        .padding()
    }
}

    // MARK: - Preview

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(timerModel: TimerModel())
            .frame(width: 300)
    }
}
