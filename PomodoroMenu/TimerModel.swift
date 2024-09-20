//
//  TimerModel.swift
//  PomodoroMenu
//
//  Created by Alex Ryan on 9/16/24.
//

import SwiftUI
import Combine
import UserNotifications
import AVFoundation

    /// `TimerModel` manages the state and behavior of the Pomodoro timer, including work sessions, rest periods,
    /// notifications, and sound playback.
class TimerModel: ObservableObject {
        // MARK: - Properties

        /// Predefined durations in seconds.
        /// - 10 sec, 30 sec, 1 min (60 sec), 3 min (180 sec), 5 min (300 sec),
        /// 10 min (600 sec), 15 min (900 sec), 20 min (1200 sec), 30 min (1800 sec),
        /// 45 min (2700 sec), 60 min (3600 sec)
    static let predefinedDurations: [Int] = [10, 30, 60, 180, 300, 600, 900, 1200, 1800, 2700, 3600]

        // MARK: - UserDefaults Keys

    private let workDurationKey = "workDuration"
    private let restDurationKey = "restDuration"
    private let longRestDurationKey = "longRestDuration"
    private let cyclesBeforeLongRestKey = "cyclesBeforeLongRest"
    private let selectedSoundNameKey = "selectedSoundName"

        // MARK: - Published Properties

        /// Duration of a work session in seconds.
    @Published var workDuration: Int = 20 * 60 { // Default to 20 minutes
        didSet {
            UserDefaults.standard.set(workDuration, forKey: workDurationKey)
            if !isResting && !isLongResting {
                remainingTime = workDuration
            }
        }
    }

        /// Duration of a short rest period in seconds.
    @Published var restDuration: Int = 5 * 60 { // Default to 5 minutes
        didSet {
            UserDefaults.standard.set(restDuration, forKey: restDurationKey)
            if isResting {
                remainingTime = restDuration
            }
        }
    }

        /// Duration of a long rest period in seconds.
    @Published var longRestDuration: Int = 30 * 60 { // Default to 30 minutes
        didSet {
            UserDefaults.standard.set(longRestDuration, forKey: longRestDurationKey)
            if isLongResting {
                remainingTime = longRestDuration
            }
        }
    }

        /// Number of work cycles before a long rest.
    @Published var cyclesBeforeLongRest: Int = 2 { // Default to 2 cycles
        didSet {
            UserDefaults.standard.set(cyclesBeforeLongRest, forKey: cyclesBeforeLongRestKey)
        }
    }

        /// Indicates whether the timer has completed a session and should show an alert/banner.
    @Published var showTimerCompletedAlert: Bool = false

        /// Enables or disables notifications.
    @Published var notificationsEnabled: Bool = true

        /// Indicates whether the timer is currently running.
    @Published var isRunning: Bool = false

        /// Indicates whether the user is currently in a rest period.
    @Published var isResting: Bool = false

        /// Indicates whether the user is currently in a long rest period.
    @Published var isLongResting: Bool = false

        /// The remaining time for the current session in seconds.
    @Published var remainingTime: Int = 20 * 60

        /// The name of the selected sound for notifications.
    @Published var selectedSoundName: String? = "Default" {
        didSet {
            UserDefaults.standard.set(selectedSoundName, forKey: selectedSoundNameKey)
        }
    }

        // MARK: - Private Properties

        /// The Combine cancellable for the timer.
    private var timer: AnyCancellable?

        /// The current cycle count.
    private var currentCycle: Int = 0

        /// The audio player for playing completion sounds.
    private var audioPlayer: AVAudioPlayer?

        // MARK: - Initialization

        /// Initializes the `TimerModel`, loading saved durations and requesting notification permissions.
    init() {
            // Load saved durations from UserDefaults
        let savedWorkDuration = UserDefaults.standard.integer(forKey: workDurationKey)
        let savedRestDuration = UserDefaults.standard.integer(forKey: restDurationKey)
        let savedLongRestDuration = UserDefaults.standard.integer(forKey: longRestDurationKey)
        let savedCyclesBeforeLongRest = UserDefaults.standard.integer(forKey: cyclesBeforeLongRestKey)
        let savedSoundName = UserDefaults.standard.string(forKey: selectedSoundNameKey) ?? "Default"

            // Update properties if saved values exist
        if savedWorkDuration > 0 {
            self.workDuration = savedWorkDuration
        }
        if savedRestDuration > 0 {
            self.restDuration = savedRestDuration
        }
        if savedLongRestDuration > 0 {
            self.longRestDuration = savedLongRestDuration
        }
        if savedCyclesBeforeLongRest > 0 {
            self.cyclesBeforeLongRest = savedCyclesBeforeLongRest
        }
        self.selectedSoundName = savedSoundName

            // Initialize remainingTime based on workDuration
        self.remainingTime = self.workDuration

            // Request notification permissions
        requestNotificationPermission()
    }

        // MARK: - Timer Control Methods

        /// Starts or pauses the timer based on the current state.
    func toggle() {
        isRunning.toggle()
        if isRunning {
            startTimer()
        } else {
            pauseTimer()
        }
    }

        /// Resets the timer to its initial values.
    func reset() {
        pauseTimer()
        isResting = false
        isLongResting = false
        isRunning = false
        remainingTime = workDuration
        currentCycle = 0
    }

        /// Sets the work duration from predefined options.
        /// - Parameter seconds: The new work duration in seconds.
    func setWorkDuration(_ seconds: Int) {
        guard TimerModel.predefinedDurations.contains(seconds) else { return }
        workDuration = seconds
        if !isResting && !isLongResting {
            remainingTime = workDuration
        }
    }

        /// Sets the rest duration from predefined options.
        /// - Parameter seconds: The new rest duration in seconds.
    func setRestDuration(_ seconds: Int) {
        guard TimerModel.predefinedDurations.contains(seconds) else { return }
        restDuration = seconds
        if isResting {
            remainingTime = restDuration
        }
    }

        /// Sets the long rest duration from predefined options.
        /// - Parameter seconds: The new long rest duration in seconds.
    func setLongRestDuration(_ seconds: Int) {
        guard TimerModel.predefinedDurations.contains(seconds) else { return }
        longRestDuration = seconds
        if isLongResting {
            remainingTime = longRestDuration
        }
    }

        // MARK: - Timer Mechanics

        /// Starts the countdown timer.
    private func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

        /// Pauses the countdown timer.
    private func pauseTimer() {
        timer?.cancel()
    }

        /// Handles each tick of the timer, decrementing the remaining time.
    private func tick() {
        guard remainingTime > 0 else {
            remainingTime = 0
            timer?.cancel()
            isRunning = false
            playCompletionSound()
            showTimerCompletedAlert = true
            toggleRestState()
            return
        }
        remainingTime -= 1
    }

        /// Toggles between work and rest states based on the current cycle.
    private func toggleRestState() {
        if isResting {
                // Rest period has ended
            isResting = false
            currentCycle += 1

            if currentCycle >= cyclesBeforeLongRest {
                    // Start long rest
                isLongResting = true
                remainingTime = longRestDuration
                isRunning = true
                startTimer()
                sendSessionCompletionNotification()
            } else {
                    // Start next work session
                remainingTime = workDuration
                isRunning = true
                startTimer()
                sendSessionCompletionNotification()
            }
        } else if isLongResting {
                // Long rest has ended
            isLongResting = false
            currentCycle = 0
            isRunning = false
            sendSessionCompletionNotification()
        } else {
                // Work period has ended
            isResting = true
            remainingTime = restDuration
            isRunning = true
            startTimer()
            sendSessionCompletionNotification()
        }
    }

        // MARK: - Notification Methods

        /// Sends a notification when a timer session completes.
    private func sendSessionCompletionNotification() {
        guard notificationsEnabled else { return }

        let content = UNMutableNotificationContent()

            // Configure notification content based on current state
        if isResting {
            content.title = "Work Session Complete"
            content.body = "Time for a short break!"
        } else if isLongResting {
            content.title = "Short Break Complete"
            content.body = "Time for a long break!"
        } else if !isRunning && !isLongResting && !isResting {
            content.title = "Long Break Complete"
            content.body = "You've completed \(cyclesBeforeLongRest) cycles! Good job!"
        } else {
            content.title = "Break Time Over"
            content.body = "Time to get back to work!"
        }

            // Configure notification sound
        if let soundName = selectedSoundName, !soundName.isEmpty, soundName != "Default" {
            content.sound = UNNotificationSound(named: UNNotificationSoundName(soundName))
        } else {
            content.sound = .default
        }

            // Trigger notification immediately with a short delay
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

        /// Requests notification permissions from the user.
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }

        // MARK: - Sound Playback

        /// Plays the completion sound when a timer session ends.
    func playCompletionSound() {
        guard let url = Bundle.main.url(forResource: "alarm-clock-beep", withExtension: "wav") else {
            print("Sound file 'alarm-clock-beep.wav' not found in the bundle.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
