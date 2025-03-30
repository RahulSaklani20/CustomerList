import SwiftUI

struct CustomerListView: View {
    @StateObject private var viewModel = CustomerViewModel()
    @State private var showActionSheet = false
    @State private var selectedCustomer: Customer?

    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.darkGray
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationView {
            VStack {
                searchBar
                customerList
            }
            .navigationTitle("CUSTOMERS")
            .navigationBarItems(trailing: Button("Cancel") {})
        }
    }

    private var searchBar: some View {
        HStack {
            TextField("Search", text: $viewModel.searchText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .padding(.trailing, 8)
                            .foregroundColor(.gray)
                    }
                )
                .font(.custom("YourCustomFontName-Regular", size: 16))
            
            Button(action: {}) {
                Image(systemName: "line.horizontal.3.decrease.circle")
                    .padding(.leading, 8)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.darkGray))
    }

    private var customerList: some View {
        List(viewModel.customers) { customer in
            CustomerTileView(customer: customer, viewModel: viewModel)
                .onTapGesture {
                    selectedCustomer = customer
                    showActionSheet = true
                }
                .listRowBackground(Color.clear)
        }
        .listStyle(PlainListStyle())
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text("Actions"),
                buttons: [
                    .default(Text("Edit")) {},
                    .default(Text(selectedCustomer?.isActive == true ? "Deactivate" : "Activate")) {
                        if let customer = selectedCustomer {
                            viewModel.toggleActiveState(for: customer)
                        }
                    },
                    .destructive(Text("Delete")) {
                        if let customer = selectedCustomer {
                            viewModel.deleteCustomer(customer)
                        }
                    },
                    .cancel()
                ]
            )
        }
    }
}

struct CustomerTileView: View {
    let customer: Customer
    @ObservedObject var viewModel: CustomerViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(customer.displayName)
                    .font(.custom("YourCustomFontName-Bold", size: 18))
                    .foregroundColor(.primary)
                if let city = customer.locations.first?.city {
                    HStack {
                        Image("locationIcon")
                            .resizable()
                            .frame(width: 16, height: 16)
                        Text(city)
                            .font(.custom("YourCustomFontName-Regular", size: 16))
                            .foregroundColor(.secondary)
                    }
                }
            }
            Spacer()
            Image(systemName: "ellipsis")
                .padding()
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.vertical, 4)
    }
}
