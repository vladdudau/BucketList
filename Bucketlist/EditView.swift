//
//  EditView.swift
//  Bucketlist
//
//  Created by user215924 on 5/1/22.
//

import SwiftUI
import UIKit

struct EditView: View {
    enum LoadingState {
        case loading, loaded, failed
    }

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: ViewModel
    var location: Location
    var onSave: (Location) -> Void

    @State private var name: String
    @State private var description: String

    @State private var loadingState = LoadingState.loading
    @State private var loadingWeatherState = LoadingState.loading
    
    @State private var pages = [Page]()
    @State private var weatherDays = [WeatherListItem]()

    
    
    struct WeatherCell : View {
        let weatherDay : WeatherListItem
        var body: some View {
            List {
                
                let hour = Calendar.current.component(.hour, from: weatherDay.dtTxt)
                if((10...12).contains(hour) || (20...23).contains(hour)) {
                    
                    HStack {
                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weatherDay.weather[0].icon)@2x.png")) { image in
                        image.resizable()
                    } placeholder: {
                        Color.red
                    }
                    .frame(width: 48, height: 48)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    VStack(alignment: .leading) {
                    Text(weatherDay.dtTxt, style:.date)
                        .font(.headline)
                    
                    
                        Text( "\(hour < 13 ? "Max temp:" : "Min temp") \(Int(weatherDay.main.temp))"   )
                    }
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
                
                Section("Local Weather") {
                    switch loadingWeatherState {
                    case .loading:
                        Text("Loading…")
                    case .loaded:
                              
                            ForEach(weatherDays, id: \.id) { day in
                                WeatherCell(weatherDay: day)
                               
    //                            +
    //                            Text(": ")
                                
    //                            + Text("\(day.main.temp)")
    //                                .italic()
                            }
                        
                    case .failed:
                        Text("Please try again later.")
                    }
                }

                Section("Nearby…") {
                    switch loadingState {
                    case .loading:
                        Text("Loading…")
                    case .loaded:
                        ForEach(pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ")
                            + Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Please try again later.")
                    }
                }
                
                Button(role: .destructive, action: {
                    
                    viewModel.locations.removeAll { arrayObj in
                        return arrayObj == location
                      }
                    dismiss()
                    
                }) {
                    Label("Delete place", systemImage: "trash")
                }
                
            }
            .navigationTitle("Place details")
            .toolbar {
                
                    Button("Save") {
                        var newLocation = location
                        newLocation.id = UUID()
                        newLocation.name = name
                        newLocation.description = description

                        onSave(newLocation)
                        dismiss()
                    
                }
                
                
            }
            .task {
                await fetchNearbyPlaces()
                
                await fetchNearbyWeather()
            }
            
        }
    }

    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave

        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }

    func fetchNearbyPlaces() async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(PlacesResponse.self, from: data)
            pages = items.query.pages.values.sorted()
            loadingState = .loaded
        } catch {
            loadingState = .failed
        }
    }
    
    func fetchNearbyWeather() async {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=ef0fd9866ca027e0dca474cee84c53be&units=metric"

        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = ("yyyy-MM-dd HH:mm:ss")
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let response = try decoder.decode(WeatherResponse.self, from: data)
            weatherDays = response.list
            loadingWeatherState = .loaded
        } catch {
            loadingWeatherState = .failed
            print("\(error)")
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
//        EditView(location: Location.example) { _ in }
        
        ContentView()
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
}
