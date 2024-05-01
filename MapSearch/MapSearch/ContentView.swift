import SwiftUI
import MapKit

struct ContentView: View {
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 26.0910, longitude: 28.0855), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    @State private var searchText = ""
    @State private var searchItems: [MKMapItem] = []
    @State private var showSearchResults = false
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: $userTrackingMode, annotationItems: searchItems) { item in
                MapPin(coordinate: item.placemark.coordinate, tint: .red)
            }
            .edgesIgnoringSafeArea(.all)
            
            TextField("Search", text: $searchText, onCommit: search)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding()
            
            if showSearchResults {
                List {
                    ForEach(searchItems) { item in
                        Text(item.name ?? "Unknown")
                            .onTapGesture {
                                region.center = item.placemark.coordinate
                                showSearchResults = false
                            }
                    }
                }
                .frame(height: 200)
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .padding()
            }
        }
    }
    
    private func search() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            searchItems = response.mapItems
            showSearchResults = true
        }
    }
}

extension MKMapItem: Identifiable {
    public var id: String {
        return name ?? UUID().uuidString
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
