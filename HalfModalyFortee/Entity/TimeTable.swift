//
//  TimeTable.swift
//  HalfModalyFortee
//
//  Created by murakami Taichi on 2019/08/07.
//  Copyright © 2019 murakammm. All rights reserved.
//

import Foundation

struct TimeTableResponse: Codable {
    var timetable: [Content]
}

struct Content: Codable, Equatable {
    enum CType: String, Codable {
        case talk
        case timeslot
    }
    
    var type: CType
    var uuid: String
    var title: String
    var abstract: String
    var track: Track
    var startsAt: Date
    var lengthMin: Int
    var speaker: Speaker?
    var favCount: Int?
    
    static var stubTalk = Content(type: .talk,
                                  uuid: "stub-uuid-talk",
                                  title: "スタブトーク",
                                  abstract: "",
                                  track: Track(name: "Track A", sort: 1),
                                  startsAt: Date(timeIntervalSinceNow: .init(floatLiteral: 0.0)),
                                  lengthMin: 15,
                                  speaker: .init(name: "スタブ太郎", kana: "すたぶたろう", twitter: "stubtarou", avatarUrl: nil),
                                  favCount: 11)
    static var stubSlot = Content(type: .timeslot,
                                  uuid: "stub-uuid-slot",
                                  title: "スタブスロット",
                                  abstract: "",
                                  track: Track(name: "Track B", sort: 2),
                                  startsAt: Date(timeIntervalSinceNow: .init(floatLiteral: 0.0)),
                                  lengthMin: 10,
                                  speaker: nil,
                                  favCount: nil)
}

struct Track: Codable, Equatable {
    var name: String
    var sort: Int
}

struct Speaker: Codable, Equatable {
    var name: String
    var kana: String
    var twitter: String?
    var avatarUrl: URL?
}
