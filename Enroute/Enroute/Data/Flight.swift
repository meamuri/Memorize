//
//  Flight.swift
//  Enroute
//
//  Created by Roman Dronov on 05.10.2020.
//

import CoreData
import Combine

extension Flight {
    var arrival: Date {
        get { arrival_ ?? Date(timeIntervalSinceReferenceDate: 0) }
        set { arrival_ = newValue }
    }
    
    var ident: String {
        get { ident_ ?? "Unknown" }
        set { ident_ = newValue }
    }
    
    var destination: Airport {
        get { destination_! }
        set { destination_ = newValue }
    }
    
    var origin: Airport {
        get { origin_! }
        set { origin_ = newValue }
    }
    
    var airline: Airline {
        get { airline_! }
        set { airline_ = newValue }
    }
    
    var number: Int {
        Int(String(ident.drop(while: { !$0.isNumber }))) ?? 0
    }
}

extension Flight {
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Flight> {
        let request = NSFetchRequest<Flight>(entityName: "Flight")
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "arrival_", ascending: true)]
        return request
    }
}

extension Flight {
    @discardableResult
    static func update(from faFlight: FAFlight, in context: NSManagedObjectContext) -> Flight {
        let request = Flight.fetchRequest(NSPredicate(format: "ident_ = %@", faFlight.ident))
        let results = (try? context.fetch(request)) ?? []
        let flight = results.first ?? Flight(context: context)
        flight.ident = faFlight.ident
        flight.origin = Airport.withICAO(faFlight.origin, context: context)
        flight.destination = Airport.withICAO(faFlight.destination, context: context)
        flight.arrival = faFlight.arrival
        flight.departure = faFlight.departure
        flight.field = faFlight.filed
        flight.aircraft = faFlight.aircraft
        flight.airline = Airline.withCode(faFlight.airlineCode, in: context)
        flight.objectWillChange.send()
        return flight
    }
}
