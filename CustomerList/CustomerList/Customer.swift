import Foundation

struct CustomerResponse: Decodable {
    let customer: [Customer]
}

struct Customer: Identifiable, Decodable {
    let id: String
    let displayName: String
    var isActive: Bool
    let locations: [Location]
    let locationErrors: [LocationError]
    
    enum CodingKeys: String, CodingKey {
        case id = "CustomerId"
        case displayName = "DisplayName"
        case isActive = "IsActive"
        case locations = "Locations"
        case locationErrors = "LocationErrors"
    }
}

struct Location: Decodable {
    let city: String
    
    enum CodingKeys: String, CodingKey {
        case city = "City"
    }
}

struct LocationError: Decodable {
    let errorType: String?
    let errorMessage: String?
}
