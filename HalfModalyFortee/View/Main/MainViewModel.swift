//
//  MainViewModel.swift
//  HalfModalyFortee
//
//  Created by murakami Taichi on 2019/08/07.
//  Copyright © 2019 murakammm. All rights reserved.
//

import Foundation
import RxSwift

final class MainViewModel {
    let timetableResponse: Observable<[Content]>
    let errorResponse: Observable<APIError>
    
    init(forteeAPI: ForteeAPIProtocol) {
        let resp = forteeAPI.timeTable().materialize().share(replay: 1)
        
        timetableResponse = resp.filter { (event: Event<[Content]>) in
            event.element != nil
        }
        .map { (event: Event<[Content]>) in
                event.element!
        }
        
        errorResponse = resp.filter { (event: Event<[Content]>) in
            event.error != nil
        }
        .map { (event: Event<[Content]>) in
                event.error as! APIError
        }
        
    }
    
    var timeTableGroupByStartAt: Observable<[ContentsGroup]> {
        return timetableResponse.map { (contents) -> [ContentsGroup] in
            contents
                .filter({ $0.title != "Q & A" })
                .reduce(into: [ContentsGroup]()) { (acc, con) in
                    if let idx =  acc.firstIndex(where: { $0.startAt == con.startsAt }) {
                        acc[idx].contents.append(con)
                    } else {
                        acc.append(ContentsGroup(startAt: con.startsAt, contents: [con]))
                    }
                }
                .sorted(by: { (l, r) -> Bool in
                    l.startAt < r.startAt
                })
        }
    }
}
