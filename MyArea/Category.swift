//
//  Category.swift
//  MyArea
//
//  Created by Marlo Kessler on 21.03.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import Foundation

enum Category: String, Hashable {
    case alle = "alle"
    case autoUndMotorad = "autoUndMotorad"
    case baby = "baby"
    case baumarkt = "baumarkt"
    case beauty = "beauty"
    case bekleidung = "bekleidung"
    case beleuchtung = "beleuchtung"
    case buecher = "buecher"
    case buerobedarfUndSchreibwaren = "buerobedarfUndSchreibwaren"
    case computerUndZubehoer = "computerUndZubehoer"
    case drogerieUndKoerperpflege = "drogerieUndKoerperpflege"
    case dvdUndBluray = "dvdUndBluray"
    case elektroGrossgeraete = "elektroGrossgeraete"
    case elektronikUndFoto = "elektronikUndFoto"
    case fashion = "fashion"
    case fastFood = "fastFood"
    case games = "games"
    case garten = "garten"
    case gewerbeIndustrieUndWissenschaft = "gewerbeIndustrieUndWissenschaft"
    case handmade = "handmade"
    case haustier = "haustier"
    case kameraUndFoto = "kameraUndFoto"
    case klassik = "klassik"
    case kofferRucksaeckeUndTaschen = "kofferRucksaeckeUndTaschen"
    case kuecheHaushaltUndWohnen = "kuecheHaushaltUndWohnen"
    case lebensmittelUndGetraenke = "lebensmittelUndGetraenke"
    case luxeryUndBeauty = "luxeryUndBeauty"
    case musik = "musik"
    case musikinstrumenteUndDJEquipment = "musikinstrumenteUndDJEquipment"
    case restaurant = "restaurant"
    case schmuck = "schmuck"
    case schuheUndHandtaschen = "schuheUndHandtaschen"
    case software = "software"
    case spielzeug = "spielzeug"
    case sportUndFreizeit = "sportUndFreizeit"
    case uhren = "uhren"
    case zeitschriften = "zeitschriften"
    case andere = "andere"
}

struct CategoryHandler {
    static var filters: [Category] = [.alle, .autoUndMotorad, .baby, .baumarkt, .beauty, .bekleidung, .beleuchtung, .buecher, .buerobedarfUndSchreibwaren, .computerUndZubehoer, .drogerieUndKoerperpflege, .dvdUndBluray, .elektroGrossgeraete, .elektronikUndFoto, .fashion, .fastFood, .games, .garten, .gewerbeIndustrieUndWissenschaft, .handmade, .haustier, .kameraUndFoto, .klassik, .kofferRucksaeckeUndTaschen, .kuecheHaushaltUndWohnen, .lebensmittelUndGetraenke, .luxeryUndBeauty, .musik, .musikinstrumenteUndDJEquipment, .restaurant, .schmuck, .schuheUndHandtaschen, .software, .spielzeug, .sportUndFreizeit, .uhren, .zeitschriften, .andere]
    
    static func getDescription(category: Category) -> String {
        switch category {
        case .alle: return "Alle"
        case .autoUndMotorad: return "Auto & Motorad"
        case .baby: return "Baby"
        case .baumarkt: return "Baumarkt"
        case .beauty: return "Beauty"
        case .bekleidung: return "Bekleidung"
        case .beleuchtung: return "Beleuchtung"
        case .buecher: return "Bücher"
        case .buerobedarfUndSchreibwaren: return "Bürobedarf & Schreibwaren"
        case .computerUndZubehoer: return "Computer & Zubehör"
        case .drogerieUndKoerperpflege: return "Drogerie & Körperpflege"
        case .dvdUndBluray: return "DVD & Blu-ray"
        case .elektroGrossgeraete: return "Elektro-Großgeräte"
        case .elektronikUndFoto: return "Elektronik & Foto"
        case .fashion: return "Fashion"
        case .fastFood: return "Fast Food"
        case .games: return "Games"
        case .garten: return "Garten"
        case .gewerbeIndustrieUndWissenschaft: return "Gewerbe, Industrie & Wissenschaft"
        case .handmade: return "Handmade"
        case .haustier: return "Haustier"
        case .kameraUndFoto: return "Kamera & Foto"
        case .klassik: return "Klassik"
        case .kofferRucksaeckeUndTaschen: return "Koffer, Rucksäcke & Taschen"
        case .kuecheHaushaltUndWohnen: return "Küche, Haushalt & Wohnen"
        case .lebensmittelUndGetraenke: return "Lebensmittel & Getränke"
        case .luxeryUndBeauty: return "Luxery & Beauty"
        case .musik: return "Musik"
        case .musikinstrumenteUndDJEquipment: return "Musikinstrumente & DJ-Equipment"
        case .restaurant: return "Restaurant"
        case .schmuck: return "Schmuck"
        case .schuheUndHandtaschen: return "Schuhe & Handtaschen"
        case .software: return "Software"
        case .spielzeug: return "Spielzeug"
        case .sportUndFreizeit: return "Sport & Freizeit"
        case .uhren: return "Uhren"
        case .zeitschriften: return "Zeitschriften"
        case .andere: return "Andere"
        }
    }
}
