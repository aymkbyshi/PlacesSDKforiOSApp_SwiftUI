import SwiftUI
import GooglePlaces

struct ContentView: View {
    @State private var showingAutocomplete = false
    @State private var placeName: String = ""
    @State private var searchText = ""
    @State private var placeDetails: GMSPlace?
    let placesClient = GMSPlacesClient.shared()

    var body: some View {
        VStack {
            SearchBar(text: $searchText)
            Text("Selected place: \(placeName)")
            Button("Launch autocomplete") {
                self.showingAutocomplete = true
            }
            Button("Get Place Details") {
                            if let placeID = self.placeDetails?.placeID {
                                fetchPlaceDetails(placeID: placeID) { place in
                                    self.placeDetails = place
                                }
                            }
                        }

                        if let place = placeDetails {
                            PlaceDetailView(place: place)
                        }
                    }
                    .sheet(isPresented: $showingAutocomplete) {
                        AutocompleteView { place in
                            self.placeName = place.name ?? "Unknown"
                            self.placeDetails = place // 選択された場所の情報を保存
                        }
                    }
    }
}

struct SearchBar: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UISearchBarDelegate {
        var parent: SearchBar

        init(_ searchBar: SearchBar) {
            self.parent = searchBar
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            parent.text = searchText
        }
    }
}


func fetchPlaceDetails(placeID: String, completion: @escaping (GMSPlace?) -> Void) {
    let fields: GMSPlaceField = [.name, .formattedAddress, .phoneNumber, .website, .rating, .photos, .priceLevel, .openingHours]
    GMSPlacesClient.shared().fetchPlace(fromPlaceID: placeID, placeFields: fields, sessionToken: nil) { (place, error) in
        if let error = error {
            print("An error occurred: \(error.localizedDescription)")
            completion(nil)
            return
        }
        completion(place)
    }
}

struct PlaceDetailView: View {
    var place: GMSPlace

    var body: some View {
        VStack(alignment: .leading) {
            Text("レストラン名: \(place.name ?? "Unknown")")
            Text("価格帯: \(priceLevelToString(place.priceLevel))")
            Text("住所: \(place.formattedAddress ?? "Not available")")
            if let phoneNumber = place.phoneNumber {
                Text("電話番号: \(phoneNumber)")
            }
            if let website = place.website {
                Text("Webサイト: \(website.absoluteString)")
            }
            // レーティングが0より大きい場合のみ表示
            if place.rating > 0 {
                Text("評価: \(place.rating)")
            }
            // 営業時間などの他の詳細を表示
            // 写真を表示するには追加の処理が必要です
        }
    }
}



// priceLevelを文字列に変換する関数
func priceLevelToString(_ priceLevel: GMSPlacesPriceLevel) -> String {
    switch priceLevel {
    case .unknown:
        return "Unknown"
    case .free:
        return "Free"
    case .cheap:
        return "Cheap"
    case .medium:
        return "Medium"
    case .high:
        return "High"
    case .expensive:
        return "Expensive"
    default:
        return "Not Available"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


