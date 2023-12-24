import SwiftUI
import GooglePlaces

struct AutocompleteTableView: UIViewRepresentable {
    @Binding var searchText: String

    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView()
        let tableDataSource = GMSAutocompleteTableDataSource()
        tableDataSource.delegate = context.coordinator

        tableView.delegate = tableDataSource
        tableView.dataSource = tableDataSource

        context.coordinator.setup(tableView: tableView, tableDataSource: tableDataSource)

        return tableView
    }

    func updateUIView(_ uiView: UITableView, context: Context) {
        context.coordinator.update(searchText: searchText)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, GMSAutocompleteTableDataSourceDelegate {
        var parent: AutocompleteTableView
        var tableDataSource: GMSAutocompleteTableDataSource?
        var tableView: UITableView?

        init(_ parent: AutocompleteTableView) {
            self.parent = parent
        }

        func setup(tableView: UITableView, tableDataSource: GMSAutocompleteTableDataSource) {
            self.tableView = tableView
            self.tableDataSource = tableDataSource
        }

        func update(searchText: String) {
            tableDataSource?.sourceTextHasChanged(searchText)
        }

        // Implement the GMSAutocompleteTableDataSourceDelegate methods here
        // ...

        // Example:
        func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
            // Do something with the selected place
            print("Place name: \(place.name)")
        }
        
        func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
                // エラーを処理する
                print("Error: \(error.localizedDescription)")
            }

            // 追加で、選択がキャンセルされた場合に呼び出されるオプショナルメソッドを実装することもできます。
            func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didSelect prediction: GMSAutocompletePrediction) -> Bool {
                // 選択された予測を処理する
                print("Prediction selected: \(prediction.attributedFullText.string)")
                return false
            }
    }
}
