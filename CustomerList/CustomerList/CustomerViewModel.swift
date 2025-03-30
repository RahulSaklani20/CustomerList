import Foundation
import Combine

class CustomerViewModel: ObservableObject {
    @Published var customers: [Customer] = []
    @Published var searchText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadCustomers()
        setupSearch()
    }
    
    private func loadCustomers() {
        guard let url = Bundle.main.url(forResource: "customerSample", withExtension: "json") else {
            print("Error: customerSample.json not found in bundle.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(CustomerResponse.self, from: data)
            self.customers = decodedData.customer
        } catch {
            print("Error loading or decoding JSON: \(error)")
        }
    }
    
    private func setupSearch() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                self?.filterCustomers(by: searchText)
            }
            .store(in: &cancellables)
    }
    
    private func filterCustomers(by searchText: String) {
        if searchText.isEmpty {
            loadCustomers()
        } else {
            customers = customers.filter { customer in
                customer.displayName.contains(searchText) ||
                customer.locations.contains { $0.city.contains(searchText) }
            }
        }
    }
    
    func toggleActiveState(for customer: Customer) {
        if let index = customers.firstIndex(where: { $0.id == customer.id }) {
            customers[index].isActive.toggle()
        }
    }
    
    func deleteCustomer(_ customer: Customer) {
        customers.removeAll { $0.id == customer.id }
    }
}
