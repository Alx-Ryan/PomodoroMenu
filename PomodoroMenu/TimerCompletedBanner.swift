//
//  TimerCompleteBanner.swift
//  PomodoroMenu
//
//  Created by Alex Ryan on 9/19/24.
//

//import SwiftUI
//
//struct TimerCompletedBanner: View {
//    @Binding var showBanner: Bool
//    var message: String
//
//    var body: some View {
//        HStack {
//            Image(systemName: "bell.fill")
//                .foregroundColor(.white)
//            Text(message)
//                .foregroundColor(.white)
//                .lineLimit(2)
//                .multilineTextAlignment(.leading)
//            Spacer()
//            Button(action: {
//                withAnimation {
//                    showBanner = false
//                }
//            }) {
//                Image(systemName: "xmark.circle.fill")
//                    .foregroundColor(.white)
//            }
//            .buttonStyle(PlainButtonStyle())
//        }
//        .frame(width: 200)
//        .padding()
//        .background(Color.accentColor)
//        .cornerRadius(8)
//        .shadow(radius: 4)
//        .padding([.leading, .trailing], 16)
//    }
//}
//#Preview {
//    TimerCompletedBanner(showBanner: .constant(true), message: "Ok")
//}
//
//  TimerCompletedBanner.swift
//  PomodoroMenu
//

import SwiftUI

    /// `TimerCompletedBanner` is a view that displays a notification banner when a timer session completes.
    /// It includes an icon, a message, and a close button.
struct TimerCompletedBanner: View {
        /// The message to display in the banner.
    var message: String

        /// Binding to control the visibility of the banner.
    @Binding var showBanner: Bool

    var body: some View {
        HStack {
            Image(systemName: "bell.fill")
                .foregroundColor(.white)
            Text(message)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
            Spacer()
            Button(action: {
                withAnimation {
                    showBanner = false
                }
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color.blue.opacity(0.8))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

    // MARK: - Preview

struct TimerCompletedBanner_Previews: PreviewProvider {
    static var previews: some View {
        TimerCompletedBanner(message: "Test Session Complete!", showBanner: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}
