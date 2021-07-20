//
//  ContentView.swift
//  Scrumdinger
//
//  Created by diayan siat on 11/07/2021.
//

import SwiftUI
import AVFoundation

struct MeetingView: View {
    // Bindings keep your model data in sync with a single source of truth so all
    //your views reflect the same data.
    @Binding var scrum: DailyScrum
    @StateObject var scrumTimer = ScrumTimer()
    var player: AVPlayer { AVPlayer.sharedDingPlayer }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16) //draws the background view
                .fill(scrum.color)
            VStack {
                
                MeetingHeaderView(secondsElapsed: scrumTimer.secondsElapsed, secondsRemaining: scrumTimer.secondsRemaining, scrumColor: scrum.color)
                
                Circle()
                    .strokeBorder(lineWidth: 24, antialiased: true)
                MeetingFooterView(speakers: scrumTimer.speakers, skipAction: scrumTimer.skipSpeaker)
            } //VStack Ending
        } //ZStack Ending
        .padding()
        .foregroundColor(scrum.color.accessibleFontColor) //modify the foreground color of the ZStack to use the accessibleFontColor property on the scrum color.
        .onAppear(perform: {
            scrumTimer.reset(lengthInMinutes: scrum.lengthInMinutes, attendees: scrum.attendees)
            //scrumTimer calls this action when a speakers time expires
            scrumTimer.speakerChangedAction = {
                player.seek(to: .zero)//seeking to time .zero ensures the audio file always plays from the beginning.
                player.play()
            }
            scrumTimer.startScrum()
        })
        .onDisappear(perform: {
            let newHistory = History(attendees: scrum.attendees, lengthInMinutes: scrumTimer.secondsElapsed/60)
            scrum.history.insert(newHistory, at: 0)
            scrumTimer.stopScrum()
        })
    }
}

struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingView(scrum: .constant(DailyScrum.data[0]))
    }
}
