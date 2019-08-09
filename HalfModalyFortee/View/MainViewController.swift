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
import Nuke

class MainViewController: UIViewController {
    @IBOutlet private weak var timeTableView: UITableView!
    let disposeBag = DisposeBag()
    enum ViewerType {
        case normal
    }
    let viewerType: ViewerType = .normal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bindViewModel()
    }
    
    func setUpUI() {
        let nib = UINib(nibName: "ContentCell", bundle: nil)
        timeTableView.register(nib, forCellReuseIdentifier: "ContentCell")
    }
    
    func bindViewModel() {
        let vm = MainViewModel(forteeAPI: ForteeAPI())
        vm.timetableResponse.map {
            $0.filter {
                switch self.viewerType {
                case .normal:
                    return $0.type == .talk
                }
            }
        }.bind(to: timeTableView.rx.items(cellIdentifier: "ContentCell", cellType: ContentCell.self)) { _, content, cell in
            cell.set(content: content)
            print(content.type)
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
        
        vm.timeTableGroupByStartAt.subscribe(onNext: { (groups) in
            print("groups \(groups[1])")
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)
    }
}

//
//extension MainViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//    typealias Element = <#type#>
//
//
//}
