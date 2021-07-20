//
//  MeetingFooterView.swift
//  Scrumdinger
//
//  Created by diayan siat on 17/07/2021.
//

import SwiftUI

struct MeetingFooterView: View {
    let speakers: [ScrumTimer.Speaker]
    var skipAction: () -> Void //skipAction closure property
//    computed property to compute number of speakers
//    ScrumTimer marks each speaker as completed when their time has ended.
//    The first speaker not marked as completed becomes the active speaker.
//    The speakerNumber property uses the index to return the active speaker number,
//    which you’ll use as part of the footer text.
    private var speakerNumber: Int? {
        guard let index = speakers.firstIndex(where: {!$0.isCompleted}) else {return nil}
        return index + 1
    }
   
//    Computed property that checks whether the active speaker is the last speaker
//    This property tests whether all speakers before the last speaker have
//    been marked as completed.
//    You can get the same result with reduce(_:_:) by returning
//    speakers.dropLast().reduce(true) { $0 && $1.isCompleted }.
    private var isLastSpeaker: Bool {
        return speakers.dropLast().allSatisfy({$0.isCompleted})
    }
    
    private var speakerText: String {
        guard let speakerNumber = speakerNumber else {return "No more speakers"}
        return "Speaker \(speakerNumber) of \(speakers.count)"
    }
    
    var body: some View {
        VStack {
            HStack {
                if isLastSpeaker {
                    Text("Last Speaker")
                }else {
                Text(speakerText)
                Spacer()
                    Button(action: skipAction) {
                    Image(systemName: "forward.fill")
                }
                .accessibilityLabel(Text("Next speaker")) //accessibility value for next button
                }
            }//HStack Ending
        }//VStack Ending
        .padding([.bottom, .horizontal])
    }
}

struct MeetingFooterView_Previews: PreviewProvider {
    static var speakers = [ScrumTimer.Speaker(name: "Kim", isCompleted: false), ScrumTimer.Speaker(name: "Bill", isCompleted: false)]

    static var previews: some View {
        //pass speakers & an empty closure to the MeetingFooterView initializer
        MeetingFooterView(speakers: speakers, skipAction: {})
            .previewLayout(.sizeThatFits)
    }
}
