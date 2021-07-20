//
//  MeetingHeaderView.swift
//  Scrumdinger
//
//  Created by diayan siat on 17/07/2021.
//

import SwiftUI

//Note here that accessibility modifiers are moved to the outer container i.e VStack
struct MeetingHeaderView: View {
    let secondsElapsed: Int
    let secondsRemaining: Int
    let scrumColor: Color
  
    //computed property to calculate progress
    private var progress: Double {
        guard secondsRemaining > 0 else {return 1}
        let totalSeconds = Double(secondsElapsed + secondsRemaining)
        return Double(secondsRemaining) / totalSeconds
    }
    
    //Because VoiceOver users don’t have the visual reference of the progress view or
    //progress ring, you’ll calculate the conversion from seconds to minutes and surface
    //the most relevant data — the minutes remaining.
    private var minutesRemaining: Int {
        secondsRemaining / 60
    }
    
    //VoiceOver will read the time remaining and append either “minute” or “minutes.”
    private var minutesRemainingMetric: String {
        minutesRemaining == 1 ? "minute" : "minutes"
    }
    
    var body: some View {
        VStack {
            //used to display time elapsed during scrum
            ProgressView(value: progress)
                .progressViewStyle(ScrumProgressViewStyle(scrumColor: scrumColor))
            HStack {
                VStack(alignment: .leading) {
                    Text("Seconds Elapsed")
                        .font(.caption)
                    Label("\(secondsElapsed)", systemImage: "hourglass.bottomhalf.fill")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Seconds Remaining")
                        .font(.caption)
                    
                    HStack {
                        Text("\(secondsRemaining)")
                        Image(systemName: "hourglass.tophalf.fill")
                    }
                }
            }
        }.accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("Time remaining")) //accessibility value for labels
        .accessibilityValue(Text("\(minutesRemaining) \(minutesRemainingMetric)")) //accessibility value for time remaining added to HStack
        .padding([.top, .horizontal]) //adjust the spacing in the top-level VStack.
    }
}

struct MeetingHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingHeaderView(secondsElapsed: 60, secondsRemaining: 60, scrumColor: DailyScrum.data[0].color)
            .previewLayout(.sizeThatFits)
    }
}
