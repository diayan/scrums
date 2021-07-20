//
//  EditView.swift
//  Scrumdinger
//
//  Created by diayan siat on 13/07/2021.
//

import SwiftUI

//I store changes to the scrum in a Data property by defining the property
//using the @State wrapper in order to mutate the property from within the view.

//SwiftUI observes @State properties and automatically redraws the view’s
//body when the property changes.
//This behavior ensures the UI stays up to date as the user manipulates
//the onscreen controls.
struct EditView: View {
    //Declare @State properties as private so they can be accessed only
    //within the view in which you define them.
  //  @State private var scrumData: DailyScrum.Data = DailyScrum.Data()
    
    //maintain a single source of truth for every piece of data in your app and
    //use bindings to share a reference to that source of truth. The edit screen should
    //act on data that the detail screen owns, instead of creating a new source of truth
    @Binding var scrumData: DailyScrum.Data
    @State private var newAttendee = "" //holds the attendee name user enters in textField
    var body: some View {
        List {
            Section(header: Text("Meeting Info")) {
                TextField("Title", text: $scrumData.title)
                HStack {
                    //A Slider stores a Double from a continuous range that you
                    //specify. Passing a step value of 1.0 limits the user to
                    //choosing whole numbers.
                    Slider(value: $scrumData.lengthInMinutes, in: 5...30, step: 1.0) {
                        Text("Length")
                    }
                    .accessibilityValue(Text("\(Int(scrumData.lengthInMinutes)) minutes"))
                    Spacer()
                    
                    Text("\(Int(scrumData.lengthInMinutes)) minutes")
                        .accessibilityHidden(true)
                }
                ColorPicker("Color", selection: $scrumData.color)
                    .accessibilityLabel(Text("Color Picker"))
            }
            
            //section for displaying, adding and deleting attendees
            Section(header: Text("Attendees")) {
                ForEach(scrumData.attendees, id: \.self) { attendee in
                    Text(attendee)
                }
                .onDelete{ indices in
                    scrumData.attendees.remove(atOffsets: indices)
                }
                
                HStack {
                    //The binding keeps the newAttendee in sync with the contents of
                    //the TextField. It doesn’t affect the original DailyScrum model data.
                    TextField("New Attendee", text: $newAttendee)
                    
                    Button(action: {
                        withAnimation{
                            scrumData.attendees.append(newAttendee)
                            newAttendee = "" //clears new attendee
                        }
                    }){
                        Image(systemName: "plus.circle.fill")
                            .accessibilityLabel(Text("Add attendee"))
                    }
                    .disabled(newAttendee.isEmpty)//disable add button when attendee textfield is empty
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(scrumData: .constant(DailyScrum.data[0].data))
    }
}
