
import SwiftUI
import GooglePlaces

struct AutocompleteSearchBar: UIViewControllerRepresentable {
    @Binding var text: String

    func makeUIViewController(context: Context) -> UIViewController {
        let resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController.delegate = context.coordinator

        let searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchResultsUpdater = resultsViewController

        let viewController = UIViewController()
        viewController.navigationItem.titleView = searchController.searchBar

        let navigationController = UINavigationController(rootViewController: viewController)
        searchController.hidesNavigationBarDuringPresentation = false
        viewController.definesPresentationContext = true

        return navigationController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update the search bar text
        if let navigationController = uiViewController as? UINavigationController,
           let viewController = navigationController.viewControllers.first,
           let searchController = viewController.navigationItem.titleView as? UISearchBar {
            searchController.text = text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, GMSAutocompleteResultsViewControllerDelegate {
        var parent: AutocompleteSearchBar

        init(_ parent: AutocompleteSearchBar) {
            self.parent = parent
        }

        func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
            parent.text = place.name ?? ""
        }

        func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
            print("Error: ", error.localizedDescription)
        }
    }
}
