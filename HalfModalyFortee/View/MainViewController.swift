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
import Rswift

class MainViewController: UIViewController {
    @IBOutlet private weak var timeTableView: UITableView!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI() {
        let nib = UINib(nibName: "ContentCell", bundle: nil)
        timeTableView.register(nib,
                               forCellReuseIdentifier: "ContentCell")
        let vm = MainViewModel()
        
        vm.timetableResponse.bind(to: timeTableView.rx.items(cellIdentifier: "ContentCell")) { _, content, cell in
            cell.textLabel?.text = content.title
            cell.detailTextLabel?.text = content.speaker?.name
        }.disposed(by: disposeBag)
        
        vm.errorResponse.subscribe(onNext: { (_: Error) in
            let alert = UIAlertController.init(title: "エラー",
                                               message: "通信に失敗しました",
                                               preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        })
        .disposed(by: disposeBag)
        
    }

}

final class MainViewModel {
    let timetableResponse: Observable<[Content]>
    let errorResponse: Observable<Error>
    
    init() {
        let resp = ForteeAPI().timeTable().materialize().share(replay: 1)
        
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
            event.error!
        }
        
    }
}

enum APIError: Error {
    case server
}

final class ForteeAPI {
    let session = URLSession.shared
    
    func timeTable() -> Observable<[Content]> {
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
            if let decoded = try? decoder.decode(TimeTableResponse.self, from: data) {
                return decoded.timetable
            } else {
                throw APIError.server
            }
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
