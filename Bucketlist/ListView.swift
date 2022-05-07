//
//  ListView.swift
//  Bucketlist
//
//  Created by user215924 on 5/2/22.
//

import SwiftUI
import MapKit

struct ListView: View {
    enum LoadingState {
        case loading, loaded, failed
    }
    @State private var loadingState = LoadingState.loading
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        NavigationView {
            
            Group {
            List(viewModel.locations) {
                location in
                    HStack {
                        Text(location.name)
                        Spacer()
                            
//                        if(loadingState == LoadingState.loaded) {
                            Text(location.country ?? "Unknown")
//                        }
                    }
                
                
            }
            }
            
                .navigationBarTitle(Text("Bucket List"))
            
        }
        
        
        
        .task {
            await fetchNearbyCountryList()
        }
    }
        
    
    func fetchNearbyCountryList() async {
        
        for index in viewModel.locations.indices {
            let location = viewModel.locations[index]
            let urlString =    "https://api.opencagedata.com/geocode/v1/json?key=4b45855ad60b43e681ea694094fd0c9c&q=\(location.coordinate.latitude)%2C+\(location.coordinate.longitude)&pretty=1&no_annotations=1"

            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let result = try JSONDecoder().decode(CountryResponse.self, from: data)
                viewModel.locations[index].country = result.results[0].components.country
                
            }
            catch {
                loadingState = .failed
            }
        }
        loadingState = .loaded
    }


        
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

