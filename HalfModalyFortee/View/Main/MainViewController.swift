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
import FloatingPanel

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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        
        timeTableView.rx.itemSelected.map { indexPath in
             ds[indexPath]
        }.subscribe(onNext: { content in
            self.presentFloatingpanel(c: content)
        }).disposed(by: disposeBag)
    }
    
    private func presentFloatingpanel(c: Content) {
        let cvc = ContentDetailViewController.loadFromNib()
        cvc.setContent(content: c)
        let fpc = FloatingPanelController(delegate: self)
        fpc.set(contentViewController: cvc)
        fpc.surfaceView.cornerRadius = 24.0
        fpc.isRemovalInteractionEnabled = true
        if let preFpc = self.presentedViewController as? FloatingPanelController {
            preFpc.dismiss(animated: true) {
                self.present(fpc, animated: true, completion: nil)
            }
        } else {
            self.present(fpc, animated: true, completion: nil)
        }
    }
}

extension MainViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return ContentFloatingPanelLayout()
    }
}

class ContentFloatingPanelLayout: FloatingPanelLayout {
    var initialPosition: FloatingPanelPosition {
        return .half
    }
    
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full:
            return 16.0
        case .half:
            return 216.0
        default:
            return nil
        }
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
