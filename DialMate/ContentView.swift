//
//  ContentView.swift
//  DialMate
//
//  Created by Johndanial on 5/18/24.
//


import SwiftUI
import SwiftData
import UserNotifications

struct ContentView: View {
    
    @StateObject var contactPermission = ContactPermission()
    
    @State private var datePicker = 1
    @State private var hour = 12
    @State private var minute = 12
    
    var body: some View {
        TabView {
            
            ContactsView()
                .tabItem {
                    Label("Home", systemImage: "house" )
                }
            NotificationsCenter()
                .tabItem {
                    Label("Notification", systemImage: "bell" )
                
                }
           
        }
        .tint(.red)
                .environmentObject(contactPermission)
            
                .task {
                    await
                    contactPermission.requestContactsPermission()
                    
                }
    }
    }


#Preview {
    ContentView()
}

