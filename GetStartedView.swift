import SwiftUI
import GooglePlaces

struct GetStartedView: View {
    @State private var name: String = ""
    @State private var address: String = ""
    private var placesClient = GMSPlacesClient.shared()

    var body: some View {
        VStack {
            Text(name).padding()
            Text(address).padding()
            Button("Get Current Place") {
                getCurrentPlace()
            }
        }
    }

    func getCurrentPlace() {
        let placeFields: GMSPlaceField = [.name, .formattedAddress]
        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: placeFields) { (placeLikelihoods, error) in
            if let error = error {
                print("Current place error: \(error.localizedDescription)")
                self.name = "Error getting current place"
                self.address = ""
                return
            }

            guard let place = placeLikelihoods?.first?.place else {
                self.name = "No current place"
                self.address = ""
                return
            }

            self.name = place.name ?? "No name"
            self.address = place.formattedAddress ?? "No address"
        }
    }
}

struct GetStartedView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedView()
    }
}
