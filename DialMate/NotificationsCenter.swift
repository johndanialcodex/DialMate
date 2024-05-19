//
//  NotificationsCenter.swift
//  DialMate
//
//  Created by Johndanial on 5/18/24.
//
import SwiftUI
import UserNotifications

struct NotificationsCenter: View {
    @State private var selectedDayIndex = 1
    @State private var selectedTime = Date()
    
    let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Picker("Select Day of the Week", selection: $selectedDayIndex) {
                        ForEach(0..<daysOfWeek.count, id: \.self) { index in
                            //                        Text(daysOfWeek[index])
                            Text(daysOfWeek[index]).tag(index)
                        }
                    }
                    .pickerStyle(.wheel)
                
                    HStack {
                        DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
                                           .pickerStyle(.navigationLink)
                        Spacer()
                            .padding()
                    }
                }
                Button(action: scheduleNotification) {
                    Text("Schedule Notification")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: ContactsView()) {
                                    Text("Test")
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                
            }
        }
        .onAppear(perform: requestNotificationPermission)
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "It's time for your scheduled notification."
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.weekday = selectedDayIndex + 1
        dateComponents.hour = calendar.component(.hour, from: selectedTime)
        dateComponents.minute = calendar.component(.minute, from: selectedTime)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for \(daysOfWeek[selectedDayIndex]) at \(selectedTime)")
            }
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
}

struct NotificationsCenter_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsCenter()
    }
}
