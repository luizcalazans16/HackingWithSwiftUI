//
//  ContentView.swift
//  Moonshot
//
//  Created by Luiz Calazans on 22/01/24.
//

import SwiftUI

struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    @AppStorage("ViewType") private var showingGrid = true
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
            NavigationStack {
                Group {
                    if showingGrid {
                        GridLayout(missions: missions, astronauts: astronauts)
                    } else {
                        ListLayout(missions: missions, astronauts: astronauts)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingGrid.toggle()
                        } label: {
                            Label(showingGrid ? "List View" : "Grid View", systemImage: showingGrid ? "list.dash" : "square.grid.2x2")
                        }
                        .foregroundColor(.white)
                    }
                }
                .navigationTitle("Moonshot")
            }
            .preferredColorScheme(.dark)
        }
        
        /// Challenge 3:
        func toggleView() {
            showingGrid.toggle()
        }
    }



#Preview {
    ContentView()
}
