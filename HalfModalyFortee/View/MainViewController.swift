//
//  MainViewController.swift
//  HalfModalyFortee
//
//  Created by murakami Taichi on 2019/08/05.
//  Copyright © 2019 murakammm. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire

class MainViewController: UIViewController {
    @IBOutlet private weak var timeTableView: UITableView!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI() {
        let vm = MainViewModel()
        vm.timetableResponse.subscribe(onNext: { result in
            print(result)
        })
        .disposed(by: disposeBag)
    }

}

final class MainViewModel {
    let timetableResponse: Observable<Result<[Content], Error>>
    init() {
        timetableResponse = ForteeAPI().timeTable()
        print(timetableResponse)
    }
}

enum APIError: Error {
    case server
}

final class ForteeAPI {
    let session = URLSession.shared
    
    func timeTable() -> Observable<Result<[Content], Error>> {
        let url = URL(string: "https://fortee.jp/iosdc-japan-2019/api/timetable")!
        let req = URLRequest(url: url)
        return session.rx.response(request: req).map { resp, data in
            if resp.statusCode != 200 {
                return Result.failure(APIError.server)
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decoded = try! decoder.decode(TimeTableResponse.self, from: data)
            return Result.success(decoded.timetable)
        }
    }
}

struct TimeTableResponse: Codable {
    var timetable: [Content]
}

struct Content: Codable {
    var type: String
    var uuid: String
    var title: String
    var abstract: String
    var track: Track
    var startsAt: String
    var lengthMin: Int
    var speaker: Speaker?
    var favCount: Int?
    
}

struct Track: Codable {
    var name: String
    var sort: Int
}

struct Speaker: Codable {
    var name: String
    var kana: String
    var twitter: String?
    var avatarUrl: URL?
}
