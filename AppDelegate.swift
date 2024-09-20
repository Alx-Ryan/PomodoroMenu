//
//  AppDelegate.swift
//  PomodoroMenu
//
//  Created by Alex Ryan on 9/16/24.
//

import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    @StateObject var timerModel = TimerModel()

    func applicationDidFinishLaunching(_ notification: Notification) {
            // Initialize Status Item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "timer", accessibilityDescription: "Pomodoro Timer")
            button.action = #selector(toggleMenu)
        }

            // Setup Menu
        let menu = NSMenu()

            // Timer Options Submenu
        let timerOptionsMenu = NSMenuItem(title: "Set Timer", action: nil, keyEquivalent: "")
        let submenu = NSMenu()
        let timerDurations: [Int] = [3, 5, 10, 15, 20, 30, 45, 60]
        for duration in timerDurations {
            let item = NSMenuItem(title: "\(duration) minutes", action: #selector(setTimerDuration(_:)), keyEquivalent: "")
            item.representedObject = duration
            submenu.addItem(item)
        }
        timerOptionsMenu.submenu = submenu
        menu.addItem(timerOptionsMenu)

            // Start/Stop Button
        let startStopTitle = timerModel.isRunning ? "Pause" : "Start"
        let startStopItem = NSMenuItem(title: startStopTitle, action: #selector(toggleTimer), keyEquivalent: "")
        menu.addItem(startStopItem)

            // Reset Button
        let resetItem = NSMenuItem(title: "Reset", action: #selector(resetTimer), keyEquivalent: "")
        menu.addItem(resetItem)

        menu.addItem(NSMenuItem.separator())

            // Quit Button
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        menu.addItem(quitItem)

        statusItem?.menu = menu
    }

    @objc func toggleMenu() {
            // No action needed; menu is automatically shown
    }

    @objc func setTimerDuration(_ sender: NSMenuItem) {
        if let duration = sender.representedObject as? Int {
            timerModel.setWorkDuration(duration)
        }
    }

    @objc func toggleTimer() {
        timerModel.toggle()
    }

    @objc func resetTimer() {
        timerModel.reset()
    }

    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}

