//
//  PomodoroMenuApp.swift
//  PomodoroMenu
//
//  Created by Alex Ryan on 9/16/24.
//

import SwiftUI
import UserNotifications

@main
struct PomodoroMenuApp: App {
    @StateObject var timerModel = TimerModel()
    @State private var showSettingsButton = false

    var body: some Scene {
        MenuBarExtra() {
            VStack {
                if showSettingsButton {
                    Text("Notifications are disabled. Please enable them in System Preferences.")
                        .padding()

                    Button("Open Settings") {
                        openSystemPreferencesForNotifications()
                    }
                    .padding()
                } else {
                    PopoverContentView(timerModel: timerModel)
                        .padding()
                }
            }
            .frame(width: 250)
            .onAppear {
                checkNotificationPermission()
            }
                // Add this modifier to listen for when the app becomes active
            .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
                checkNotificationPermission()
            }
        } label: {
                // Use the custom label view
            MenuBarLabelView(timerModel: timerModel)
        }
        .menuBarExtraStyle(.window)
    }

    private func checkNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .denied {
                        // If denied, show the prompt to go to System Preferences
                    showSettingsButton = true
                } else {
                        // If allowed, hide the settings button
                    showSettingsButton = false
                }
            }
        }
    }

    private func openSystemPreferencesForNotifications() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.notifications") {
            NSWorkspace.shared.open(url)
        }
    }
}
