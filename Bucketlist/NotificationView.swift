//
//  NotificationView.swift
//  Bucketlist
//
//  Created by user215924 on 5/3/22.
//

import SwiftUI
import UserNotifications

class NotificationManager : ObservableObject {
    @Published var children : [String] = []
    
    var center = UNUserNotificationCenter.current()
    
    func stopNotification() {
        center.removeAllPendingNotificationRequests()
    }
    
    func sendNotification(title: String, body: String) {
        //Step 1: get the user notification center
        //Step 2: request notification authorization
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
          if let error = error {
          // Handle the error here.
        }}
        // Check notification permission
        center.getNotificationSettings { settings in
          guard (settings.authorizationStatus == .authorized) ||
            (settings.authorizationStatus == .provisional) else { return }
          if settings.alertSetting == .enabled {
            // Schedule an alert-only notification.
          } else {
            // Schedule a notification with a badge and sound.
          }
        }
        //Step 3: deliver a local notification
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.userInfo["info"] = "info"
        content.badge = NSNumber(value: 2)
        
        // Notification daily
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.weekday = 3  // Tuesday
        dateComponents.hour = 14    // 14:00 hours
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Send local notification in 5 seconds (testing purposes)
        let trigger_test = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // Step 4: create a request and register the request to the user notification center.
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,             content: content, trigger: trigger)
        center.add(request) { (error) in
          if error != nil {      // Handle any errors.
        }}
        
        // test
        let uuidString2 = UUID().uuidString
        let request2 = UNNotificationRequest(identifier: uuidString,             content: content, trigger: trigger_test)
        center.add(request2) { (error) in
          if error != nil {      // Handle any errors.
        }}
        
    }
    
}
struct NotificationView: View {
    @State var isOn: Bool = false
    @State var notificationsOn: Bool = false
    @StateObject private var manager = NotificationManager()
    var body: some View {
        NavigationView {
            VStack {
                Toggle("Receive daily notifications", isOn: $notificationsOn ).onChange(of: notificationsOn)
                {
                    value in
                        if(value) {
                            manager.sendNotification(title: "BucketList Reminder", body: "Please check out new features!")
                        }
                    else {
                        manager.stopNotification()
                    }
                }
                
                    
                
                

                if (notificationsOn) {
                    Text("Notifications every Tuesday at 14:00 to arrive!")
                    
                }
                
                Spacer()
            }
            
            .padding()
            .navigationTitle(Text("Notifications"))
            
        }
       
    }
        
            
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
