//
//  LookAtSpendingItemView.swift
//  MoneyHealth
//
//  Created by Egor Petrov on 07.11.2020.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LookAtSpendingItemView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GenericConfigurableCellComponent {

    typealias ViewData = LookAtSpendingsItemViewData
    typealias Model = LookAtSpendingsItemModel

    var model: Model?

    var disposeBag = DisposeBag()

    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Look at your spendings"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        return label
    }()

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    var items = [SpendingItemModel]()

    override init(frame: CGRect) {
        super.init(frame: frame)

        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        layout.scrollDirection = .horizontal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayout() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview()
        }

        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(180)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(24)
            make.bottom.equalToSuperview()
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithType(GenericCollectionViewCell<SpendingView>.self, indexPath: indexPath)
        cell.customSubview.configure(with: self.items[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        self.items[indexPath.row].onTap?()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 132, height: 180)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func configure(with model: LookAtSpendingsItemModel) {
        self.model = model
        bindOutput(from: model)
    }

    func bindOutput(from model: LookAtSpendingsItemModel) {
        model.items
            .bind(to: self.rx.items)
            .disposed(by: self.disposeBag)
    }
}

extension Reactive where Base: LookAtSpendingItemView {

    var items: Binder<[SpendingItemModel]> {
        return Binder(self.base) { view, items in
            view.items = items
            view.collectionView.reloadData()
        }
    }
}
