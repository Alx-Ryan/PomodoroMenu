//
//  StartPauseButton.swift
//  PomodoroMenu
//
//  Created by Alex Ryan on 9/19/24.
//

import SwiftUI

struct StartPauseButton: View {
    @ObservedObject var timerModel: TimerModel

    var body: some View {
            /// Start/Pause Button with Enhanced Design
        Button(action: {
            withAnimation(.easeInOut(duration: 0.15)) {
                timerModel.toggle()
            }
        }) {
            HStack {
                    // Icon changes based on timer state
                Image(systemName: timerModel.isRunning ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20) // Reduced icon size for smaller button
                    .foregroundColor(.white)

                    // Button label changes based on timer state
                Text(timerModel.isRunning ? "Pause" : "Start")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .padding(8) // Reduced padding for smaller button size
            .frame(width: 85, height: 40) // Fixed size for consistency
            .background(timerModel.isRunning ? Color.mutedOrange.opacity(0.7) : Color.mutedGreen.opacity(0.7)) // Less bright colors
            .cornerRadius(10) // Slightly smaller corner radius for elegance
            .shadow(color: timerModel.isRunning ? Color.mutedOrange.opacity(0.3) : Color.mutedGreen.opacity(0.3), radius: 3, x: 0, y: 3) // Subtle shadow
        }
        .buttonStyle(PlainButtonStyle()) // Removes default button styling for custom appearance
    }
}
