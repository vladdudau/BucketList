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
            if error != nil {
                return;
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
        let trigger2 = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let trigger3 = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
        
        
        // Step 4: create a request and register the request to the user notification center.
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,             content: content, trigger: trigger)
        center.add(request)
        
        // test request 5 seconds
        let uuidString2 = UUID().uuidString
        let request2 = UNNotificationRequest(identifier: uuidString2,             content: content, trigger: trigger2)
        center.add(request2)
        
        
        // test request 5 seconds
        let uuidString3 = UUID().uuidString
        let request3 = UNNotificationRequest(identifier: uuidString3,             content: content, trigger: trigger3)
        center.add(request3)
    }
    
}
struct NotificationView: View {
    
    @State private var animationEnabled = false
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
                    VStack {
                        Text("Notifications every Tuesday at 14:00 to arrive!")
                        Rectangle()
                            .fill(animationEnabled ? Color.cyan : Color.pink)
                            .frame(width:50, height:50)
                            .rotationEffect(.degrees(animationEnabled ? 0 : 360))
                            .opacity(animationEnabled ? 0 : 1)
                            .scaleEffect(CGFloat(animationEnabled ? 1.0 : 2.1))
                            .offset(x: CGFloat(animationEnabled ? -150 : 125), y: 50)
                            .animation(Animation.spring().repeatForever(autoreverses: true), value: animationEnabled)
                            .onAppear() {
                                // First Animation States
                                animationEnabled = true
                            }
                            .onDisappear() {
                                animationEnabled = false
                            }
                    }
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
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
}
