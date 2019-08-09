//
//  ForteeAPIStub.swift
//  HalfModalyFortee
//
//  Created by murakami Taichi on 2019/08/09.
//  Copyright © 2019 murakammm. All rights reserved.
//

import Foundation
import RxSwift

final class ForteeAPIStub: ForteeAPIProtocol {
    let values: [Content]
    init(contents: [Content]) {
        values = contents
    }
    func timeTable() -> Observable<[Content]> {
        return Observable.of(values)
    }
}

final class ForteeAPIGroupStub: ForteeAPIProtocol {
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
