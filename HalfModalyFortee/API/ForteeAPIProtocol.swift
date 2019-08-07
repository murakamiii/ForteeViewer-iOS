//
//  ForteeAPIProtocol.swift
//  HalfModalyFortee
//
//  Created by murakami Taichi on 2019/08/07.
//  Copyright © 2019 murakammm. All rights reserved.
//

import Foundation
import RxSwift
import Reachability

enum APIError: Error, Equatable {
    case server
    case network
}

protocol ForteeAPIProtocol {
    func timeTable() -> Observable<[Content]>
}

final class ForteeAPIStub: ForteeAPIProtocol {
    func timeTable() -> Observable<[Content]> {
        return Observable.of([Content.stubTalk, Content.stubSlot])
    }
}

final class ForteeAPIStubError: ForteeAPIProtocol {
    let errorValue: APIError
    init(errorValue: APIError) {
        self.errorValue = errorValue
    }
    
    func timeTable() -> Observable<[Content]> {
        return Observable<[Content]>.create { ob in
            ob.onError(self.errorValue)
            return Disposables.create()
        }
    }
}

final class ForteeAPI: ForteeAPIProtocol {
    let session = URLSession.shared
    
    func timeTable() -> Observable<[Content]> {
        let connection = try? Reachability().connection
        guard connection != .unavailable else {
            return Observable<[Content]>.create { ob in
                ob.onError(APIError.network)
                return Disposables.create()
            }
        }
        
        let url = URL(string: "https://fortee.jp/iosdc-japan-2019/api/timetable")!
        let req = URLRequest(url: url)
        //        AF.request(url).responseData { resp in
        //            if let data = resp.data {
        //                let decoder = JSONDecoder()
        //                decoder.keyDecodingStrategy = .convertFromSnakeCase
        //                let decoded = try! decoder.decode(TimeTableResponse.self, from: data)
        //
        //            }
        //        }
        return session.rx.response(request: req).map { _, data in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            if let decoded = try? decoder.decode(TimeTableResponse.self, from: data) {
                return decoded.timetable
            } else {
                throw APIError.server
            }
        }
    }
}


