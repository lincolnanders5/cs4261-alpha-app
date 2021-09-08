//
//  ContentView.swift
//  Shared
//
//  Created by Lincoln Anders on 9/7/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		TabView {
			PostList()
				.tabItem { Label("Posts", systemImage: "list.dash") }
			
			PostCreateDetail()
				.tabItem { Label("New", systemImage: "plus") }
			
			VStack {
				Text("Account").font(.headline)
			}.tabItem { Label("Account", systemImage: "person.fill") }
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
