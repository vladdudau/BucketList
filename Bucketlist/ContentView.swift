//
//  ContentView.swift
//  Bucketlist
//
//  Created by user215924 on 5/1/22.
//


import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        TabView {
            MapView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Map")
                }
            ListView()
                .tabItem {
                    Image(systemName: "list.number.rtl")
                    Text("BucketList")
                }
            NotificationView()
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }
        }
        .environmentObject(viewModel)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
