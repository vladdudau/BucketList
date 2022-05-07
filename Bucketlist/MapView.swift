//
//  MapView.swift
//  Bucketlist
//
//  Created by user215924 on 5/2/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @State var song1 = false
    @StateObject private var soundManager = SoundManager()
    
    
    var body: some View {
        
        ZStack {
            Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    
                    VStack {
                        Image(systemName: "person.crop.circle.badge.checkmark")
                            .resizable()
                            .foregroundColor(.green)
                            .frame(width: 42, height: 42)
                            .background(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 10))

                        Text(location.name)
                            .fixedSize()
                    }
                    .onTapGesture {
                        viewModel.selectedPlace = location
                    }
                }
            }
            .ignoresSafeArea()

            Circle()
                .fill(.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)

            VStack {
                Spacer()

                HStack {
                    Spacer()
                    
                    VStack {
                    
                        Button {
                            print("DA")
                            soundManager.playSound(sound: "https://audionautix.com/Music/CloserToJazz.mp3")
                                           song1.toggle()
                                           
                                           if song1{
                                               soundManager.audioPlayer?.play()
                                           } else {
                                               soundManager.audioPlayer?.pause()
                                           }
                        } label: {
                            Image(systemName: song1 ?  "speaker.slash":  "speaker.2")
                                            
                        }
                        .padding()
                        .background(.black.opacity(0.75))
                        .foregroundColor(.white)
                        .font(.title)
                        .clipShape(Circle())
                        .padding(.trailing)
                        
                        Button {
                            viewModel.addLocation()
                        } label: {
                            Image(systemName: "plus")
                        }
                        .padding()
                        .background(.black.opacity(0.75))
                        .foregroundColor(.white)
                        .font(.title)
                        .clipShape(Circle())
                        .padding(.trailing)
                    }
                }
            }
        }
        .sheet( item: $viewModel.selectedPlace) { place in
            EditView(location: place) { newLocation in
                viewModel.update(location: newLocation)
            }
        }
    }
    
    func returnLocations() -> [Location] {
        return viewModel.locations
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
