//
//  ContactsView.swift
//  DialMate
//
//  Created by Johndanial on 5/18/24.
//

import SwiftUI
import SwiftData
import UserNotifications

struct ContactsView: View {
    @EnvironmentObject var contactPermission: ContactPermission
    @State private var friends: [Contact] = []
    
    @State private var friend = Contact(givenName: "", familyName: "", phoneNumbers: [])
    
    @State private var addingNewFriendFromContacts = false
    
    
    @State private var rotation: Double = 0.0
    @State private var rotation1: Double = 0.0
    @State private var rotation2: Double = 0.0
    
    @State private var animateGradient = false
    
    var body: some View {
        
      

        
        
      
        VStack {
            HStack{
                Spacer()
                
                    .overlay(
                        ZStack {
                            UnevenRoundedRectangle(
                                topLeadingRadius: 90,
                                bottomLeadingRadius: 20,
                                bottomTrailingRadius: 70,
                                topTrailingRadius: 0
                            )
                            .fill(Color.blue)
                            .frame(width: 290, height: 70)
                            .shadow(radius: 10)
                            .shadow(radius: 30)
                            .shadow(radius: 30)
                           
                            
                            Text("Contact Selected:  \(friends.count)")
                                              .foregroundStyle(.yellow)
                                              .font(.system(size: 25))                                              .bold()
                        }
                            .offset(x: 70, y:10)
                    )

                Spacer()
                  
                Button {
                    addingNewFriendFromContacts = true
                } label: {
                    Label("", systemImage: "person.crop.circle.badge.plus")

                        .font(.system(size: 50))
                        .foregroundColor(.white)
                        .bold()
                        .shadow(radius: 10)
                        .shadow(radius: 30)
                        .shadow(radius: 30)
                     
                }
                .padding(10)
                
                
            }
            
            Spacer()

            
            ZStack {
          
                Text("\(friend.givenName) \(friend.familyName)")
                    .foregroundColor(.white)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .frame(width: 230, height: 100)
             
                    .font(.largeTitle)
                    .bold()
                    .minimumScaleFactor(0.6)
 
                    .lineLimit(9)
            }
            
            .overlay (
                Capsule()
                
                    .stroke(lineWidth: 5)
                    .frame(width: 250, height: 250)
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                    .shadow(radius: 30)
                    .shadow(radius: 30)
            )
            
            
            .padding(100)
            
            
            
            
            Button("Random Contact") {
                if let randomContact = friends.randomElement() {
                    friend = randomContact
                }
            }
            .foregroundColor(.white)
            .font(.system(size: 40))
            .bold()
            .shadow(radius: 10)
            .shadow(radius: 30)
            .shadow(radius: 30)
            
            .overlay (
                Capsule()
                
                    .stroke(lineWidth: 5)
                    .frame(width: 350, height: 50)
                    .foregroundColor(.white)
            )
            
            
            Spacer()
            
            
                .sheet(isPresented: $addingNewFriendFromContacts)
            {
                    AddingFriendsView(friends: $friends)
                        .onDisappear {
                            
                            DirectoryService.writeModelToDisk(friends)
                        }
                    
                }
            
            
          
            
            HStack {
                ZStack{
                    
                    Circle().fill(Color.blue).frame(width: 110)
                    Circle().fill(Color.white).frame(width: 90)
                    
                    Link(destination: URL(string: "tel:\(friend.phoneNumbers.first ?? "")")!) {
                        Image(systemName: "phone.badge.waveform.fill")
                            .font(.system(size: 70))
                        
                        
                    }
                    
                }
                .padding(40)
                Spacer()
                
                ZStack{
                    Circle().fill(Color.green).frame(width: 110)

                    Circle().fill(Color.white).frame(width: 90)
                    
                    Link(destination: URL(string: "sms:\(friend.phoneNumbers.first ?? "")")!) {
                        Image(systemName: "message.badge.waveform.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 70))
                    }
                    .foregroundColor(.blue)
                    
                }
                .padding(40)
            }
        }
        .onAppear {
            if let friends: [Contact] = try? DirectoryService.readModelFromDisk() {
                self.friends = friends
                
            }
        }
    
        .background(
            LinearGradient(colors: [.blue, .cyan,.white], startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                .hueRotation(.degrees(animateGradient ? 25 : 0))
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                }
        )
    }
    func checkForPermission() {
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { setting in
            switch setting.authorizationStatus {
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                    if didAllow {
                        self.dispatchNotification()
                    }
                }
            case .denied:
                return
            case .authorized:
                self.dispatchNotification()
            default:
                return
            }
            
        }
   
    }

        
        func dispatchNotification(){
            let identifier = "My daily notification"
            let title = "Time to work out"
            let body = "dont wate time"
            let hour = 2
            let minute = 00
            let isDaily = true
            
            let notificationCenter = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            
            content.title = title
            content.body = body
            content.sound = .default
            
            let calendar = Calendar.current
            var dareComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
            dareComponents.hour = hour
            dareComponents.minute = minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dareComponents, repeats: isDaily)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
            notificationCenter.add(request)
            
            
    }
}

#Preview {
    ContactsView()
        .environmentObject(ContactPermission())
}
