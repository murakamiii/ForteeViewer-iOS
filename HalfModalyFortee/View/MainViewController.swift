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
import RxDataSources
import SwiftDate
import Nuke

class MainViewController: UIViewController {
    @IBOutlet private weak var timeTableView: UITableView!
    
    enum ViewerType {
        case normal
    }
    let viewerType: ViewerType = .normal
    let disposeBag = DisposeBag()

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
        timeTableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        let vm = MainViewModel(forteeAPI: ForteeAPI())
//        vm.timetableResponse.map {
//            $0.filter {
//                switch self.viewerType {
//                case .normal:
//                    return $0.type == .talk
//                }
//            }
//        }.bind(to: timeTableView.rx.items(cellIdentifier: "ContentCell", cellType: ContentCell.self)) { _, content, cell in
//            cell.set(content: content)
//            print(content.type)
//        }.disposed(by: disposeBag)
        
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
        
        let ds = RxTableViewSectionedReloadDataSource<ContentsGroup>(configureCell: { ds, table, indexPath, item in
                let cell = table.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! ContentCell
                cell.set(content: item)
                return cell
        }, titleForHeaderInSection: { ds, idx in
            let d = ds.sectionModels[idx].startAt.convertTo(region: Region.current)
            return "\(d.month)/\(d.day) \(d.hour):\(d.minute)~"
        })
        vm.timeTableGroupByStartAt
            .bind(to: timeTableView.rx.items(dataSource: ds))
            .disposed(by: disposeBag)
    }
}

extension ContentsGroup: SectionModelType {
    typealias Item = Content
    init(original: ContentsGroup, items: [ContentsGroup.Item]) {
        self = original
        self.contents = items
    }
    
    var items: [Content] {
        return self.contents
    }
}

extension MainViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        <#code#>
//    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
}
