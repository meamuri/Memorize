//
//  Airport.swift
//  Enroute
//
//  Created by Roman Dronov on 05.10.2020.
//

import CoreData
import Combine
import MapKit

extension Airport: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public var title: String? { name ?? icao }
    public var subtitle: String? { location }
}

extension Airport {
    static func withICAO(_ icao: String, context: NSManagedObjectContext) -> Airport {
        // look up icao in Core Data
        let request = fetchRequest(NSPredicate(format: "icao_ = %@", icao))        
        request.sortDescriptors = [NSSortDescriptor(key: "location", ascending: true)]
        let airports = (try? context.fetch(request)) ?? []
        if let airport = airports.first {
            return airport
        } else {
            let airport = Airport(context: context)
            airport.icao = icao
            AirportInfoRequest.fetch(icao) { airportInfo in
                self.update(from: airportInfo, context: context)
            }
            return airport
        }
    }
    
    static func update(from info: AirportInfo, context: NSManagedObjectContext) {
        if let icao = info.icao {
            let airport = self.withICAO(icao, context: context)
            airport.latitude = info.latitude
            airport.longitude = info.longitude
            airport.name = info.name
            airport.location = info.location
            airport.timezone = info.timezone
            airport.objectWillChange.send()
            airport.flightsFrom.forEach { $0.objectWillChange.send() }
            airport.flightsTo.forEach { $0.objectWillChange.send() }
            try? context.save()
        }
    }
    
    var flightsTo: Set<Flight> {
        get { flightsTo_ as? Set<Flight> ?? [] }
        set { flightsTo_ = newValue as NSSet }
    }
    
    var flightsFrom: Set<Flight> {
        get { flightsFrom_ as? Set<Flight> ?? [] }
        set { flightsFrom_ = newValue as NSSet }
    }
}

extension Airport: Comparable { //, Identifiable {
    var icao: String {
        get { icao_! }
        set { icao_ = newValue}
    }
    
    var friendlyName: String {
        let friendly = AirportInfo.friendlyName(name: self.name ?? "", location: self.location ?? "")
        return friendly.isEmpty ? icao : friendly
    }
    
    public var id: String { icao }
    
    public static func < (lhs: Airport, rhs: Airport) -> Bool {
        lhs.location ?? lhs.friendlyName < rhs.location ?? rhs.friendlyName
    }
}

extension Airport {
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Airport> {
        let request = NSFetchRequest<Airport>(entityName: "Airport")
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "location", ascending: true)]
        return request
    }
}

extension Airport {
    func fetchIncomingFlights() {
        Self.flightsAwareRequest?.stopFetching()
        if let context = managedObjectContext {
            Self.flightsAwareRequest = EnrouteRequest.create(airport: icao, howMany: 120)
            Self.flightsAwareRequest?.fetch(andRepeatEvery: 10)
            Self.flightsAwareResultsCancellable = Self.flightsAwareRequest?.results.sink { results in
                for faFlight in results {
                    Flight.update(from: faFlight, in: context)
                }
                do {
                    try context.save()
                } catch(let error) {
                    print("Couldn't save flight update to CoreData: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private static var flightsAwareRequest: EnrouteRequest!
    private static var flightsAwareResultsCancellable: AnyCancellable?
}
