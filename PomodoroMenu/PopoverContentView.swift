//
//  PopoverContentView.swift
//  PomodoroMenu
//
//  Created by Alex Ryan on 9/16/24.
//

import SwiftUI

    /// `PopoverContentView` is the primary view displayed within the app's popover.
    /// It presents the timer's progress, control buttons, and an expandable settings section.
struct PopoverContentView: View {
        // MARK: - Observed Objects

        /// The `TimerModel` instance managing the timer's state and behavior.
    @ObservedObject var timerModel: TimerModel

        // MARK: - State Properties

        /// Controls the visibility of the completion banner.
    @State private var showBanner: Bool = false

        /// Tracks the selected segment in the Picker.
    @State private var selectedTab: SettingsTab = .timer

        // MARK: - Enum for Segmented Picker

        /// Enum representing the available tabs in the Picker.
    enum SettingsTab: String, CaseIterable, Identifiable {
        case timer = "Timer"
        case settings = "Settings"

        var id: String { self.rawValue }
    }

    var body: some View {
        VStack {
            Picker(selection: $selectedTab) {
                ForEach(SettingsTab.allCases) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            } label: {

            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if selectedTab == .timer {
                    // timerView
                VStack(spacing: 10) {
                        // MARK: - Timer Progress View

                        /// Displays the timer's progress and remaining time.
                    ProgressViews(timerModel: timerModel)
                        .padding(.top)

                        // MARK: - Control Buttons

                    HStack(spacing: 20) {
                            /// Start/Pause Button
                        StartPauseButton(timerModel: timerModel)

                            /// Reset Button
                        ResetButton(timerModel: timerModel)
                    }
                    .padding(.horizontal)

                    Spacer()
                        // MARK: - Completion Banner Overlay

                    if showBanner {
                        TimerCompletedBanner(message: alertMessage, showBanner: $showBanner)
                            .padding()
                            .transition(.move(edge: .bottom))
                            .onAppear {
                                    // Automatically hide the banner after 3 seconds
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    if showBanner {
                                        withAnimation {
                                            showBanner = false
                                        }
                                    }
                                }
                            }
                            .zIndex(1) // Ensure the banner appears above other views
                    }
                }
                .padding()
                .frame(width: 300)
            } else {
                ScrollView {
                    SettingsView(timerModel: timerModel)
                }
            }
        }

        .padding(30)
        .frame(width: 300)

            // Listen for timer completion alerts to show the banner
        .onReceive(timerModel.$showTimerCompletedAlert) { showAlert in
            if showAlert {
                withAnimation {
                    showBanner = true
                }
                timerModel.showTimerCompletedAlert = false // Reset the alert flag
            }
        }
    }

        // MARK: - Computed Properties

        /// Generates an appropriate alert message based on the timer's current state.
    private var alertMessage: String {
        if timerModel.isResting {
            return "Work session complete. Time for a short break!"
        } else if timerModel.isLongResting {
            return "Short break over. Time for a long rest!"
        } else if !timerModel.isRunning && !timerModel.isLongResting && !timerModel.isResting {
            return "Long break complete. You've completed \(timerModel.cyclesBeforeLongRest) cycles!"
        } else {
            return "Break over. Time to get back to work!"
        }
    }
}

    // MARK: - Preview

struct PopoverContentView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverContentView(timerModel: TimerModel())
    }
}
