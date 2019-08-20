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
    }
    
    func bindViewModel() {
        let vm = MainViewModel(forteeAPI: ForteeAPI())
        
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
            return "\(d.month)/\(d.day) \(d.hour):\(String(format: "%02d", d.minute))~"
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
