//
//  TimerView.swift
//  PomodoroMenu
//
//  Created by Alex Ryan on 9/19/24.
//

import SwiftUI

    /// `TimerView` displays the timer's progress and control buttons.
struct TimerView: View {
    @ObservedObject var timerModel: TimerModel
    @Binding var showBanner: Bool

    var body: some View {
        VStack(spacing: 20) {
                // Timer Progress View
            ProgressViews(timerModel: timerModel)
                .padding(.top)

                // Control Buttons
            HStack(spacing: 20) {
                    /// Start/Pause Button
                StartPauseButton(timerModel: timerModel)

                    /// Reset Button
                ResetButton(timerModel: timerModel)
            }
            .padding(.horizontal)
        }
    }
}
