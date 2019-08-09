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
                                  startsAt: ISO8601DateFormatter().date(from: "2019-09-05T17:50:00+09:00")!,
                                  lengthMin: 15,
                                  speaker: .init(name: "スタブ太郎", kana: "すたぶたろう", twitter: "stubtarou", avatarUrl: nil),
                                  favCount: 11)
    
    static var stubTalk2 = Content(type: .talk,
                                  uuid: "stub-uuid-talk-2222",
                                  title: "スタブトーク2",
                                  abstract: "",
                                  track: Track(name: "Track B", sort: 2),
                                  startsAt: ISO8601DateFormatter().date(from: "2019-09-05T17:50:00+09:00")!,
                                  lengthMin: 15,
                                  speaker: .init(name: "スタブ太郎2", kana: "すたぶたろう2", twitter: "stubtarou2", avatarUrl: nil),
                                  favCount: 11)
    
    static var stubTalk3 = Content(type: .talk,
                                   uuid: "stub-uuid-talk-3333",
                                   title: "スタブトーク3",
                                   abstract: "",
                                   track: Track(name: "Track B", sort: 2),
                                   startsAt: ISO8601DateFormatter().date(from: "2019-09-05T17:50:01+09:00")!,
                                   lengthMin: 15,
                                   speaker: .init(name: "スタブ太郎3", kana: "すたぶたろう3", twitter: "stubtarou3", avatarUrl: nil),
                                   favCount: 11)
    
    static var stubSlot = Content(type: .timeslot,
                                  uuid: "stub-uuid-slot",
                                  title: "スタブスロット",
                                  abstract: "",
                                  track: Track(name: "Track B", sort: 2),
                                  startsAt: ISO8601DateFormatter().date(from: "2019-09-05T17:49:00+09:00")!,
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

struct ContentsGroup {
    var startAt: Date
    var contents: [Content]
}
