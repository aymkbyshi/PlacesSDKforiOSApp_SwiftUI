import SwiftUI
import GooglePlaces

struct PlacePhotoView: View {
    @State private var placePhoto: UIImage? = nil
    @State private var photoAttribution: NSAttributedString? = nil
    @State private var errorMessage: String? = nil
    
    let placeID: String
    let placesClient = GMSPlacesClient.shared()
    
    var body: some View {
        VStack {
            if let placePhoto = placePhoto {
                Image(uiImage: placePhoto)
                    .resizable()
                    .scaledToFit()
            }
            
            if let photoAttribution = photoAttribution {
                Text(photoAttribution.string)
                    .lineLimit(nil)
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .onAppear(perform: loadPlacePhoto)
    }
    
    private func loadPlacePhoto() {
        let fields: GMSPlaceField = [.photos]
        placesClient.fetchPlace(fromPlaceID: placeID,
                                placeFields: fields,
                                sessionToken: nil) { (place, error) in
            if let error = error {
                errorMessage = "An error occurred: \(error.localizedDescription)"
                return
            }
            
            if let place = place, let photoMetadata = place.photos?.first {
                placesClient.loadPlacePhoto(photoMetadata) { (photo, error) in
                    if let error = error {
                        errorMessage = "Error loading photo metadata: \(error.localizedDescription)"
                    } else {
                        placePhoto = photo
                        photoAttribution = photoMetadata.attributions
                    }
                }
            }
        }
    }
}



struct PlacePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        // ここで実際のPlace IDを使用するか、テスト用のダミーIDを使用してください。
        // 例えば: "ChIJN1t_tDeuEmsRUsoyG83frY4" (シドニーのオペラハウス)
        PlacePhotoView(placeID: "ChIJCewJkL2LGGAR3Qmk0vCTGkg")
    }
}
