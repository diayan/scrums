//
//  DetailView.swift
//  Scrumdinger
//
//  Created by diayan siat on 13/07/2021.
//

import SwiftUI

//The edit screen now passes changes back to the detail screen.
//Using a binding ensures that DetailView re-renders when scrum is modified.
struct DetailView: View {
    @Binding var scrum: DailyScrum
    //source of truth for the binding added to EditView
    @State private var data: DailyScrum.Data = DailyScrum.Data()
    @State private var isPresented = false
    var body: some View {
        List {
            Section(header: Text("Meeting Info")) {
                //This row will act as a trigger to navigate to the meeting view.
                NavigationLink(
                    destination: MeetingView(scrum: $scrum)) {
                        Label("Start Meeting", systemImage: "timer")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .accessibilityLabel(Text("start meeting"))
                    }
                HStack {
                    Label("Length", systemImage: "clock")
                        .accessibilityLabel(Text("meeting length"))
                    Spacer()
                    Text("\(scrum.lengthInMinutes) minutes")
                }
                HStack {
                    Label("Color", systemImage: "paintpalette")
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(scrum.color)
                }
                .accessibilityElement(children: .ignore)
            }
            Section(header: Text("Attendees")) {
                ForEach(scrum.attendees, id: \.self) { attendee in
                    Label(attendee, systemImage: "person")
                        .accessibilityLabel(Text("person"))
                        .accessibilityValue(Text(attendee))
                }
            }
            
            Section(header: Text("History")) {
                if scrum.history.isEmpty {
                    Label("No meetings yet", systemImage: "calendar.badge.exclamationmark")
                }
                
                ForEach(scrum.history) { history in
                    HStack {
                        Image(systemName: "calendar")
                        //Text(_:style:) displays a localized date or time. For
                        //more styles, refer to the Text.DateStyle documentation.
                        Text(history.date, style: .date)
                    }
                }
            }
        }//End of list
        .listStyle(InsetGroupedListStyle())
        .navigationBarItems(trailing: Button("Edit") {
            isPresented = true
            data = scrum.data
        })
        .navigationTitle(scrum.title)
        .fullScreenCover(isPresented: $isPresented) {
            NavigationView {
                EditView(scrumData: $data)
                    .navigationTitle(scrum.title)
                    .navigationBarItems(leading: Button("Cancel") {
                        isPresented = false
                    }, trailing: Button("Done") {
                        isPresented = false
                        scrum.update(from: data)
                    })
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            // Pass a constant binding to the DetailView initializer in DetailView_Previews.
            DetailView(scrum: .constant(DailyScrum.data[0]))
        }
    }
}
