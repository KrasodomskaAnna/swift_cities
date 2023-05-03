import UIKit
import CoreLocation

class City : NSObject {
    var id: Int
    var name: String
    var sketch: String
    var location: CLLocation
    var keywords: [String]
    var locations: [Location]
    
    enum LocationType: String {
        case pub
        case museum
        case monument
        case park
        case restaurant
        case cafe
        case club
        case beach
        case artGallery = "art gallery"
        case botanicalGarden = "botanical garden"
        case theater
        case zoo
        case stadium
        case musicVenue = "music venue"
        case canal
        case chocolateShop = "chocolate shop"
    }
    
    struct Location {
        let id: Int
        let type: LocationType
        let name: String
        let rating: Int
        
        var description: String {
            return "type: " + type.rawValue + ", name: " + name + ", rating: " + String(rating)
        }
    }
    
    init(id: Int, name: String, description: String, latitude: Double, longitude: Double, keywords: [String], locations: [Location]) {
        self.id = id
        self.name = name
        self.sketch = description
        self.location = CLLocation(latitude: latitude, longitude: longitude)
        self.keywords = keywords
        self.locations = locations
    }
    
    public override var description: String {
        return "name: " + name + ", " + locationDesctiption(location: self.location)
    }
    
    func distance(city: City) -> Double {
        return distance(location: city.location)
    }
    
    func distance(location: CLLocation) -> Double {
        return self.location.distance(from: location)
    }
    
    func get5Rating() -> [Location] {
        return self.locations.filter{$0.rating == 5}
    }
    
    func averageLocations() -> Double {
        return Double(self.locations.map{$0.rating}.reduce(0){$0 + $1}) / Double(self.locations.count)
    }
}

func locationDesctiption(location: CLLocation) -> String {
    return "latitude: " + String(location.coordinate.latitude) + ", longitude: " + String(location.coordinate.longitude)
}

func filterCities(cities: [City], name: String) -> [City] {
    return cities.filter{$0.name == name}
}

func filterCities(cities: [City], keyword: String) -> [City] {
    return cities.filter{$0.keywords.contains(keyword)}
}

func closestAndFarthestCity(cities: [City], location: CLLocation) -> (City, City) {
    let sorted = cities.sorted{ $0.distance(location: location) < $1.distance(location: location) }
    return (sorted[0], sorted[sorted.count-1])
}

func farthestCities(cities: [City]) -> (City, City) {
    var choosen1 : City = cities[0]
    var choosen2 : City = cities[0]
    var distance : Double = 0
    var tmp : Double
    for i in 0..<cities.count {
        for j in i+1..<cities.count {
            c1 = cities[i]
            c2 = cities[j]
            tmp = c1.distance(city: c2)
            if (tmp > distance) {
                distance = tmp
                choosen1 = c1
                choosen2 = c2
            }
        }
    }
    return (choosen1, choosen2)
}

func citiesWith5StarRestaurants(cities: [City]) -> [City] {
    var newList : [City] = []
    for c in cities {
        // or !c.get5Rating().filter{$0.type == .restaurant}.isEmpty
        if (!c.locations.filter{$0.type == .restaurant && $0.rating == 5}.isEmpty) {
            newList.append(c)
        }
    }
    return newList
}

func locationsSorted(city: City) -> [City.Location] {
    return city.locations.sorted{$0.rating > $1.rating}
}

func printCitie5StarRating(cities: [City]) {
    for c in cities {
        var locations = c.get5Rating()
        print(c, "number of locations: ", String(locations.count))
        for l in locations {
            print("\t\t\t", l.description)
        }
    }
}


var cities: [City] = [
    City(id: 1, name: "Dublin", description: "The capital of Ireland, known for its pubs, music and literature", latitude: 53.3498, longitude: -6.2603, keywords: ["music", "history", "nature"], locations: [
        City.Location(id: 1, type: .pub, name: "The Temple Bar Pub", rating: 4),
        City.Location(id: 2, type: .museum, name: "The National Museum of Ireland", rating: 3),
        City.Location(id: 3, type: .park, name: "Phoenix Park", rating: 1)
    ]),
    City(id: 2, name: "Dublin", description: "A city in Ohio, United States, known for its parks and festivals", latitude: 40.0992, longitude: -83.1141, keywords: ["nature", "sport", "music"], locations: [
        City.Location(id: 4, type: .park, name: "Coffman Park", rating: 3),
        City.Location(id: 5, type: .pub, name: "Dublin Irish Pub", rating: 2),
        City.Location(id: 6, type: .restaurant, name: "Mezzo Italian Kitchen and Wine", rating: 4)
    ]),
    City(id: 3, name: "Sofia", description: "The capital and largest city of Bulgaria, known for its history and culture", latitude: 42.6977, longitude: 23.3219, keywords: ["history", "culture", "nature"], locations: [
        City.Location(id: 7, type: .monument, name: "Alexander Nevsky Cathedral", rating: 3),
        City.Location(id: 8, type: .museum, name: "National Archaeological Museum", rating: 4),
        City.Location(id: 9, type: .restaurant, name: "Nikolas", rating: 3)
    ]),
    City(id: 4, name: "Gdynia", description: "A port city on the Baltic coast of Poland, known for its modernist architecture and seaside atmosphere", latitude: 54.5189, longitude: 18.5305, keywords: ["seaside", "architecture", "culture"], locations: [
            City.Location(id: 1, type: .beach, name: "Orłowo Beach", rating: 4),
            City.Location(id: 2, type: .monument, name: "Kościuszko Square", rating: 3),
            City.Location(id: 3, type: .restaurant, name: "Restauracja Biały Królik", rating: 5),
            City.Location(id: 4, type: .park, name: "Skwer Kościuszki", rating: 4),
            City.Location(id: 5, type: .artGallery, name: "Muzeum Miasta Gdyni", rating: 4)
        ]),
        City(id: 5, name: "Bristol", description: "A city in southwest England, known for its maritime history and music scene", latitude: 51.4545, longitude: -2.5879, keywords: ["music", "history", "nature"], locations: [
            City.Location(id: 1, type: .museum, name: "Bristol Museum & Art Gallery", rating: 4),
            City.Location(id: 2, type: .park, name: "Brandon Hill Nature Park", rating: 3),
            City.Location(id: 3, type: .restaurant, name: "The Ox", rating: 4),
            City.Location(id: 4, type: .club, name: "Thekla", rating: 3),
            City.Location(id: 5, type: .musicVenue, name: "O2 Academy Bristol", rating: 4)
        ]),
        City(id: 6, name: "Bristol", description: "A city in Tennessee, United States, known for its outdoor activities and festivals", latitude: 36.5951, longitude: -82.1887, keywords: ["nature", "sport", "music"], locations: [
            City.Location(id: 1, type: .park, name: "Steele Creek Park", rating: 1),
            City.Location(id: 2, type: .restaurant, name: "620 State", rating: 4),
            City.Location(id: 3, type: .monument, name: "Birthplace of Country Music Museum", rating: 4),
            City.Location(id: 4, type: .musicVenue, name: "Paramount Center for the Arts", rating: 3),
            City.Location(id: 5, type: .zoo, name: "Stonewall Jackson Lake State Park", rating: 4)
        ]),

    City(id: 7, name: "Paris", description: "The capital of France, known for its art, fashion, and food", latitude: 48.8566, longitude: 2.3522, keywords: ["art", "fashion", "food"], locations: [
        City.Location(id: 1, type: .museum, name: "The Louvre", rating: 5),
        City.Location(id: 2, type: .restaurant, name: "Le Jules Verne", rating: 4),
        City.Location(id: 3, type: .artGallery, name: "Centre Georges Pompidou", rating: 4),
        City.Location(id: 4, type: .park, name: "Jardin des Tuileries", rating: 4),
        City.Location(id: 5, type: .monument, name: "Eiffel Tower", rating: 5)
    ]),
    City(id: 8, name: "Rome", description: "The capital of Italy, known for its history, art, and architecture", latitude: 41.9028, longitude: 12.4964, keywords: ["history", "art", "architecture"], locations: [
        City.Location(id: 1, type: .museum, name: "The Vatican Museums", rating: 5),
        City.Location(id: 2, type: .restaurant, name: "La Pergola", rating: 4),
        City.Location(id: 3, type: .monument, name: "The Colosseum", rating: 5),
        City.Location(id: 4, type: .park, name: "Villa Borghese", rating: 4),
        City.Location(id: 5, type: .artGallery, name: "Galleria Borghese", rating: 4)
    ]),
    City(id: 9, name: "Berlin", description: "The capital of Germany, known for its history, culture, and nightlife", latitude: 52.5200, longitude: 13.4050, keywords: ["history", "culture", "nightlife"], locations: [
        City.Location(id: 1, type: .museum, name: "Pergamon Museum", rating: 4),
        City.Location(id: 2, type: .restaurant, name: "Rutz Weinbar", rating: 1),
        City.Location(id: 3, type: .club, name: "Berghain", rating: 3),
        City.Location(id: 4, type: .monument, name: "Brandenburg Gate", rating: 2),
        City.Location(id: 5, type: .park, name: "Tiergarten", rating: 4)
    ]),
    City(id: 10, name: "Barcelona", description: "A vibrant city on the Mediterranean coast known for its art, architecture, and nightlife", latitude: 41.3851, longitude: 2.1734, keywords: ["seaside", "party", "sport", "music"], locations: [
        City.Location(id: 1, type: .pub, name: "Razzmatazz", rating: 4),
        City.Location(id: 2, type: .restaurant, name: "Can Solé", rating: 5),
        City.Location(id: 3, type: .park, name: "Park Güell", rating: 5),
        City.Location(id: 4, type: .beach, name: "Barceloneta Beach", rating: 4),
        City.Location(id: 5, type: .artGallery, name: "Picasso Museum", rating: 5)
    ]),

    City(id: 11, name: "Vienna", description: "The capital of Austria, known for its art, music, and coffee culture", latitude: 48.2082, longitude: 16.3738, keywords: ["art", "music", "food"], locations: [
        City.Location(id: 1, type: .artGallery, name: "Belvedere Palace", rating: 5),
        City.Location(id: 2, type: .restaurant, name: "Figlmüller", rating: 4),
        City.Location(id: 3, type: .club, name: "Flex", rating: 3),
        City.Location(id: 4, type: .park, name: "Stadtpark", rating: 4),
        City.Location(id: 5, type: .museum, name: "Kunsthistorisches Museum", rating: 5)
    ]),

    City(id: 12, name: "Stockholm", description: "The capital of Sweden, known for its architecture, design, and Nordic cuisine", latitude: 59.3293, longitude: 18.0686, keywords: ["architecture", "design", "food"], locations: [
        City.Location(id: 1, type: .restaurant, name: "Oaxen Krog & Slip", rating: 5),
        City.Location(id: 2, type: .park, name: "Djurgården", rating: 4),
        City.Location(id: 3, type: .museum, name: "Vasa Museum", rating: 5),
        City.Location(id: 4, type: .artGallery, name: "Modern Art Museum", rating: 4),
        City.Location(id: 5, type: .theater, name: "Royal Dramatic Theatre", rating: 5)
    ]),
    City(id: 13, name: "Athens", description: "The capital of Greece, known for its ancient history and culture", latitude: 37.9838, longitude: 23.7275, keywords: ["history", "culture", "food"], locations: [
        City.Location(id: 1, type: .monument, name: "Acropolis", rating: 4),
        City.Location(id: 2, type: .museum, name: "National Archaeological Museum", rating: 4),
        City.Location(id: 3, type: .restaurant, name: "Karamanlidika tou Fani", rating: 4),
        City.Location(id: 4, type: .park, name: "National Garden", rating: 3),
        City.Location(id: 5, type: .cafe, name: "Taf Coffee", rating: 4)
    ]
),
    City(id: 14, name: "Edinburgh", description: "The capital of Scotland, known for its history, culture, and festivals", latitude: 55.9533, longitude: -3.1883, keywords: ["history", "culture", "music"], locations: [
        City.Location(id: 1, type: .monument, name: "Edinburgh Castle", rating: 4),
        City.Location(id: 2, type: .museum, name: "National Museum of Scotland", rating: 4),
        City.Location(id: 3, type: .restaurant, name: "The Witchery by the Castle", rating: 4),
        City.Location(id: 4, type: .park, name: "Holyrood Park", rating: 4),
        City.Location(id: 5, type: .pub, name: "The Royal Oak", rating: 3)
    ]),
    City(id: 15, name: "Copenhagen", description: "The capital of Denmark, known for its design, architecture, and hygge lifestyle", latitude: 55.6761, longitude: 12.5683, keywords: ["design", "architecture", "food"], locations: [
        City.Location(id: 1, type: .monument, name: "The Little Mermaid", rating: 3),
        City.Location(id: 2, type: .museum, name: "Ny Carlsberg Glyptotek", rating: 4),
        City.Location(id: 3, type: .restaurant, name: "Noma", rating: 3),
        City.Location(id: 4, type: .park, name: "Tivoli Gardens", rating: 4),
        City.Location(id: 5, type: .cafe, name: "The Living Room", rating: 3)
    ]),
    City(id: 16, name: "Lisbon", description: "The capital of Portugal, known for its historic neighborhoods, culture, and nightlife", latitude: 38.7223, longitude: -9.1393, keywords: ["history", "culture", "nightlife"], locations: [
        City.Location(id: 1, type: .restaurant, name: "Time Out Market Lisboa", rating: 4),
        City.Location(id: 2, type: .museum, name: "Museu Nacional do Azulejo", rating: 3),
        City.Location(id: 3, type: .club, name: "Lux Frágil", rating: 3),
        City.Location(id: 4, type: .park, name: "Jardim da Estrela", rating: 4),
        City.Location(id: 5, type: .monument, name: "Belém Tower", rating: 3)
    ]),
    City(id: 17, name: "Krakow", description: "A historic city in southern Poland, known for its architecture, art, and music", latitude: 50.0647, longitude: 19.9450, keywords: ["history", "art", "music"], locations: [
        City.Location(id: 1, type: .museum, name: "National Museum in Krakow", rating: 4),
        City.Location(id: 2, type: .restaurant, name: "Pierogi Mr. Vincent", rating: 5),
        City.Location(id: 1, type: .artGallery, name: "MOCAK", rating: 5),
        City.Location(id: 2, type: .restaurant, name: "Wierzynek", rating: 4),
        City.Location(id: 4, type: .park, name: "Planty Park", rating: 4),
        City.Location(id: 5, type: .club, name: "Shakers Club", rating: 5)
    ]),
    City(id: 18, name: "Bruges", description: "A picturesque city in Belgium, known for its canals, medieval architecture, and chocolate", latitude: 51.2093, longitude: 3.2247, keywords: ["canals", "architecture", "food"], locations: [
        City.Location(id: 1, type: .canal, name: "Dijver Canal", rating: 4),
        City.Location(id: 2, type: .chocolateShop, name: "The Chocolate Line", rating: 4),
        City.Location(id: 3, type: .monument, name: "Belfry of Bruges", rating: 3)]),
    City(id: 19, name: "Dubrovnik", description: "A walled city on the Adriatic coast of Croatia, known for its beautiful Old Town and stunning seaside views", latitude: 42.6507, longitude: 18.0944, keywords: ["seaside", "history", "architecture"], locations: [City.Location(id: 1, type: .monument, name: "Walls of Dubrovnik", rating: 4), City.Location(id: 2, type: .beach, name: "Banje Beach", rating: 4), City.Location(id: 3, type: .restaurant, name: "Nautika Restaurant", rating: 3), City.Location(id: 4, type: .artGallery, name: "Art Gallery Dubrovnik", rating: 3), City.Location(id: 5, type: .park, name: "Gradac Park", rating: 4)]),
    City(id: 20, name: "Warsaw", description: "The capital of Poland, known for its history, culture, and nightlife", latitude: 52.2297, longitude: 21.0122, keywords: ["history", "culture", "nightlife"], locations: [        City.Location(id: 3, type: .monument, name: "Wawel Royal Castle", rating: 3), City.Location(id: 1, type: .museum, name: "Polin Museum of the History of Polish Jews", rating: 4), City.Location(id: 2, type: .club, name: "Level 27", rating: 4), City.Location(id: 3, type: .restaurant, name: "Atelier Amaro", rating: 3), City.Location(id: 4, type: .theater, name: "Teatr Wielki - Polish National Opera", rating: 4), City.Location(id: 5, type: .monument, name: "Warsaw Uprising Monument", rating: 4)])]

print("Cities with name Sofia:")
var result = filterCities(cities: cities, name: "Sofia")
for c in result {
    print(c)
}

print("\n\nCities with keyword party:")
result = filterCities(cities: cities, keyword: "party")
for c in result {
    print(c)
}

var location = CLLocation(latitude: 54.3520, longitude: 18.6466)
print("\n\nfor location: " + locationDesctiption(location: location) + " (Gdańsk)")
var c1: City
var c2: City
(c1, c2) = closestAndFarthestCity(cities: cities, location: location)
print("closest:\t", c1, "\nfarthest:\t", c2)


print("\n\ntwo farthest cities from city’s array")
(c1, c2) = farthestCities(cities: cities)
print(c1)
print(c2)


print("\n\ncities which have restaurants with 5 star rating")
result = citiesWith5StarRestaurants(cities: cities)
for c in result {
    print(c)
}

print("\n\nlist of related locations sorted by rating for Gdańsk")
let gdansk = City(
    id: 21,
    name: "Gdańsk",
    description: "A city in northern Poland, known for its rich history and beautiful architecture",
    latitude: 54.3520, longitude: 18.6466,
    keywords: ["history", "architecture", "seaside"],
    locations: []
)
let gdanskLocations = [
    City.Location(id: 1, type: .museum, name: "National Maritime Museum", rating: 4),
    City.Location(id: 2, type: .monument, name: "Neptune's Fountain", rating: 5),
    City.Location(id: 3, type: .restaurant, name: "Piwna 47 Restaurant", rating: 4),
    City.Location(id: 4, type: .park, name: "Oliwa Park", rating: 4),
    City.Location(id: 5, type: .club, name: "Protokultura", rating: 3),
]
gdansk.locations = gdanskLocations
var loc = locationsSorted(city: gdansk)
for l in loc {
    print(l.description)
}

print("\n\ncities with information how many location with 5 star rating they have")
printCitie5StarRating(cities: cities)

print("\n\naverage of locations for cities")
for c in cities {
    print(c.name, round(c.averageLocations() * 100) / 100.0)
}
