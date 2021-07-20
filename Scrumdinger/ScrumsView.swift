//
//  ScrumsView.swift
//  Scrumdinger
//
//  Created by diayan siat on 11/07/2021.
//

import SwiftUI

struct ScrumsView: View {
    @Binding var scrums: [DailyScrum]
    @State var isPresented = false
    @State var newScrumData = DailyScrum.Data() //source of truth for all changes user makes the new scrum
    
    var body: some View {
        //A list initializer accepts a ViewBuilde(ForEach) as its only parameter
        List {
            //ForEach initialized with a collection along with a closure that creates a view for each item
            //The closure returns a CardView for each element in the scrums array.
            ForEach(scrums) { scrum in
                NavigationLink(destination: DetailView(scrum: binding(for: scrum))) {
                    CardView(scrum: scrum)
                    
                }
                .listRowBackground(scrum.color)
            }
        }.navigationTitle(Text("Daily Scrums"))
        .navigationBarItems(trailing: Button(action: {
            isPresented = true
        }) {
            Image(systemName: "plus")
        })
        .sheet(isPresented: $isPresented) {
            NavigationView {
                EditView(scrumData: $newScrumData)
                    .navigationBarItems(leading: Button("Dismiss", action: {
                        isPresented = false
                    }), trailing: Button("Add", action: {
                        
//                        The properties of newScrumData are bound to the controls of
//                        EditView and have the current info that the user set. The
//                        scrums array contains elements of DailyScrum, so you’ll need
//                        to create a new DailyScrum to insert into the array.
                        let newScrum = DailyScrum(title: newScrumData.title, attendees: newScrumData.attendees, lengthInMinutes: Int(newScrumData.lengthInMinutes), color: newScrumData.color)
                       
//                        The scrums array is a binding, so updating the array in this
//                        view updates the source of truth contained in the app.
                        scrums.append(newScrum)
                        isPresented = false
                    }))
            }
        }
    }
    
    
    //    The ForEach view passes a scrum into its closure, but the DetailView
    //    initializer expects a binding to a scrum. You’ll add a utility method to retrieve a
    //    binding from an individual scrum.
    private func binding(for scrum: DailyScrum) -> Binding<DailyScrum> {
        guard let scrumIndex = scrums.firstIndex(where: {$0.id == scrum.id}) else {
            fatalError("Can't find scrum in array")
        }
        //The $ prefix accesses the projected value of a wrapped property. The projected
        //value of the scrums binding is another binding.
        return $scrums[scrumIndex]
    }
}



struct ScrumsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ForEach(ColorScheme.allCases, id: \.self, content: ScrumsView(scrums: .constant(DailyScrum.data)).preferredColorScheme)
        }
    }
}
