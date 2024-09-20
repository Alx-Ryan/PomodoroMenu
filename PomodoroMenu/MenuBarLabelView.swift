//
//  MenuBarLabelView.swift
//  PomodoroMenu
//
//  Created by Alex Ryan on 9/19/24.
//

import SwiftUI

struct MenuBarLabelView: View {
    @ObservedObject var timerModel: TimerModel

    var body: some View {
        HStack(spacing: 4) {
                Image(systemName: timerModel.isRunning ? "timer" : "pause.circle")
                    .foregroundColor(timerModel.isRunning ? .green : .red)
                Text(timerText)
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                    .foregroundColor(.primary)
            
            Text(timerText)
                .font(.system(size: 12, weight: .regular, design: .monospaced))
                .foregroundColor(.primary)
        }
    }

    private var timerText: String {
        let minutes = timerModel.remainingTime / 60
        let seconds = timerModel.remainingTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
