//
//  AboutView.swift
//  Bucketlist
//
//  Created by user217570 on 5/7/22.
//

import SwiftUI
import WebKit
import AVKit


struct WebView: UIViewRepresentable {
 
    var url: URL
 
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

struct WebBrowserView : View {
    let link : String
    var body: some View {
        WebView(url: URL(string: link)!)
    }
}

struct ShareSheetView: View {
    let link : String
    var body: some View {
        Button(action: actionSheet) {
            Image(systemName: "square.and.arrow.up")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 36, height: 36)
        }
    }
    
    func actionSheet() {
        guard let data = URL(string: link) else { return }
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}

struct SimpleVideoPlayer: View {
    
    let videoLink : String
    

    var body: some View {
        let player = AVPlayer(url: URL(string: videoLink)!)
        VideoPlayer(player: player)
        .onAppear() {
            player.play()
        }
    }
}

struct AboutView: View {
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    Text("BucketList app made by")
                    Text("Dudau Vlad-George & Mindrescu Albert-Codrin")
                        .fontWeight(.bold)
                        .lineLimit(nil)
                    Text("FMI UNIBUC 2021-2022")
                }
                Spacer()
                VStack {
                    NavigationLink("Open official page", destination: WebBrowserView(link: "https://github.com/vladdudau/bucketlist"))
                
                    ShareSheetView(link: "https://github.com/vladdudau/bucketlist")
                }
                Spacer()
                NavigationLink("View Devs' Favourite Location", destination: SimpleVideoPlayer(videoLink: "https://thumbsnap.com/i/wnXdGjkz.mp4"))
                    Spacer()
                }
            
            .padding()
            .navigationTitle(Text("About app"))
            .navigationViewStyle(StackNavigationViewStyle())
        }
        
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
