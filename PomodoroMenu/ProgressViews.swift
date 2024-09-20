//
//  ProgressViews.swift
//  PomodoroMenu
//
//  Created by Alex Ryan on 9/16/24.
//

import SwiftUI

struct ProgressViews: View {
    @ObservedObject var timerModel: TimerModel

    var body: some View {
        ZStack {
            BackgroundProgressView(themeColor: themeColor)
            TimerProgressView(
                color1: gradientColor1,
                color2: gradientColor2,
                totalDuration: totalDuration,
                remainingTime: timerModel.remainingTime
            )
            VStack {
                Text(timeString(time: timerModel.remainingTime))
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .foregroundColor(.primary)
                Text(currentPhase)
                    .font(.headline)
                    .foregroundColor(themeColor)
            }
        }
        .frame(width: 200, height: 200)
    }

        // MARK: - Computed Properties

    private var themeColor: Color {
        if timerModel.isLongResting {
            return .purple
        } else if timerModel.isResting {
            return .green
        } else {
            return .pink
        }
    }

    private var gradientColor1: Color {
        if timerModel.isLongResting {
            return .purple
        } else if timerModel.isResting {
            return .yellow
        } else {
            return .red
        }
    }

    private var gradientColor2: Color {
        if timerModel.isLongResting {
            return .pink
        } else if timerModel.isResting {
            return .green
        } else {
            return .orange
        }
    }

    private var totalDuration: Int {
        if timerModel.isLongResting {
            return timerModel.longRestDuration //* 60
        } else if timerModel.isResting {
            return timerModel.restDuration //* 60
        } else {
            return timerModel.workDuration// * 60
        }
    }

    private var currentPhase: String {
        if timerModel.isLongResting {
            return "Long Rest"
        } else if timerModel.isResting {
            return "Rest"
        } else {
            return "Work"
        }
    }

        // MARK: - Helper Methods

//    private func timeString(time: Int) -> String {
//        let minutes = time / 60
//        let seconds = time % 60
//        return String(format: "%02d:%02d", minutes, seconds)
//    }

    private func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        if minutes > 0 {
            return String(format: "%02d:%02d", minutes, seconds)
        } else {
            return "\(seconds) sec"
        }
    }
}

struct TimerProgressView: View {
    let color1: Color
    let color2: Color
    let totalDuration: Int
    let remainingTime: Int

    var body: some View {
        Circle()
            .trim(from: 0.1, to: mappedProgress)
            .stroke(
                AngularGradient(
                    gradient: Gradient(colors: [color1, color2]),
                    center: .center,
                    startAngle: .degrees(70),
                    endAngle: .degrees(300)
                ),
                style: StrokeStyle(lineWidth: 10, lineCap: .round)
            )
            .rotationEffect(.degrees(90))
            .animation(.linear(duration: 1), value: remainingTime)
            .frame(width: 180, height: 180)
    }

        // MARK: - Computed Properties

    private var mappedProgress: CGFloat {
        let rawProgress = progress
        return 0.1 + rawProgress * 0.8
    }

    private var progress: CGFloat {
        let total = CGFloat(totalDuration)
        let current = CGFloat(remainingTime)
        return total > 0 ? current / total : 0
    }
}

struct BackgroundProgressView: View {
    let themeColor: Color

    var body: some View {
        Circle()
            .trim(from: 0.1, to: 0.9)
            .stroke(themeColor.opacity(0.2),
                    style: StrokeStyle(lineWidth: 10, lineCap: .round))
            .frame(width: 180, height: 180)
            .rotationEffect(.degrees(90))
    }
}

struct ProgressViews_Previews: PreviewProvider {
    static var previews: some View {
        let previewModel = TimerModel()
        previewModel.isRunning = false
        previewModel.isResting = true
        previewModel.workDuration = 20 // 20 minutes
        previewModel.restDuration = 5  // 5 minutes
        previewModel.remainingTime = 5 * 60  // 10 minutes remaining in seconds

        return ProgressViews(timerModel: previewModel)
    }
}
