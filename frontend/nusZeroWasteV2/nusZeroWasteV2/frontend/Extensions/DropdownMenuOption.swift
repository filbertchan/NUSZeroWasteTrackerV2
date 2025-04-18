//
//  DropdownMenuOption.swift
//  nusZeroWasteV2
//
//  Created by Beng Beng on 25/7/24.
//

import Foundation

struct DropdownMenuOption: Identifiable, Hashable {
    let id = UUID().uuidString
    let option: String
}

extension DropdownMenuOption {
    static let stationTest: DropdownMenuOption = DropdownMenuOption(option: "March")
    static let stationList: [DropdownMenuOption] = [
        DropdownMenuOption(option: "BTC"),
        DropdownMenuOption(option: "Duke"),
        DropdownMenuOption(option: "Raffles Hall"),
        DropdownMenuOption(option: "Technoedge Canteen"),
        DropdownMenuOption(option: "E7 Building"),
        DropdownMenuOption(option: "EW1A, Faculty of Engineering"),
        DropdownMenuOption(option: "1 Kent Ridge Road"),
        DropdownMenuOption(option: "2 Prince George’s Park"),
        DropdownMenuOption(option: "3 Prince George’s Park"),
        DropdownMenuOption(option: "5 Kent Ridge Road"),
        DropdownMenuOption(option: "5 Prince George’s Park"),
        DropdownMenuOption(option: "Central Library"),
        DropdownMenuOption(option: "King Edward VII Hall"),
        DropdownMenuOption(option: "Lee Kong Chian Natural History Museum (LKCNHM)"),
        DropdownMenuOption(option: "NUS Staff Club"),
        DropdownMenuOption(option: "Office of Campus Security"),
        DropdownMenuOption(option: "Ridge View Residential College"),
        DropdownMenuOption(option: "Technology Centre for Offshore and Marine Singapore"),
        DropdownMenuOption(option: "Tropical Marine Science Institute (TSMI)"),
        DropdownMenuOption(option: "University Cultural Centre (UCC)"),
        DropdownMenuOption(option: "University Sports Centre"),
        DropdownMenuOption(option: "Yong Siew Toh Conservatory of Music (YSTCM)"),
        DropdownMenuOption(option: "Yusof Ishak House (YIH)"),
        DropdownMenuOption(option: "Prince George’s Park Residences"),
        DropdownMenuOption(option: "Centre for Life Sciences (CELS)"),
        DropdownMenuOption(option: "Department of Mathematics"),
        DropdownMenuOption(option: "Faculty of Dentistry"),
        DropdownMenuOption(option: "Frontier Canteen"),
        DropdownMenuOption(option: "MD1, Tahir Foundation Building"),
        DropdownMenuOption(option: "MD11, Yong Loo Lin School of Medicine"),
        DropdownMenuOption(option: "Near Block S4A"),
        DropdownMenuOption(option: "S9, Wet Science Building"),
        DropdownMenuOption(option: "MD6, Centre for Translational Medicine"),
        DropdownMenuOption(option: "University Hall"),
        DropdownMenuOption(option: "AS8 building"),
        DropdownMenuOption(option: "Eusoff Hall"),
        DropdownMenuOption(option: "I3 (I-Cube) Building"),
        DropdownMenuOption(option: "Institute of Systems Science (ISS)"),
        DropdownMenuOption(option: "Kent Ridge Hall"),
        DropdownMenuOption(option: "Mochtar Riady Building"),
        DropdownMenuOption(option: "Shaw Foundation Alumni House (SFAH)"),
        DropdownMenuOption(option: "Sheares Hall"),
        DropdownMenuOption(option: "Temasek Hall"),
        DropdownMenuOption(option: "Terrace Canteen"),
        DropdownMenuOption(option: "Ventus building"),
        DropdownMenuOption(option: "COM-3"),
        DropdownMenuOption(option: "I4.0 building (Innovation 4.0)"),
        DropdownMenuOption(option: "The Deck Canteen"),
        DropdownMenuOption(option: "College of Alice and Peter Tan"),
        DropdownMenuOption(option: "Stephan Riady Centre"),
        DropdownMenuOption(option: "Tembusu / Cinnamon College"),
        DropdownMenuOption(option: "UTown Residences, North Tower"),
        DropdownMenuOption(option: "UTown Residences, South Tower"),
        DropdownMenuOption(option: "Yale-NUS College - 12 College Ave West"),
        DropdownMenuOption(option: "Yale-NUS College - 28 College Ave West"),
        DropdownMenuOption(option: "Horticultural Activities - Utown"),
        DropdownMenuOption(option: "Kent Vale Estate"),

    ]
}
