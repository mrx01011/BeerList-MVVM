//
//  BeerView.swift
//  BeerList-MVVM
//
//  Created by MacBook on 22.01.2024.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class BeerView: UIView {
    private let beerImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.snp.makeConstraints {
            $0.height.width.equalTo(UIScreen.main.bounds.height / 3.5)
        }
    }
    private let idLabel = UILabel().then {
        $0.textColor = UIColor.orange
        $0.text = ""
        $0.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    }
    private let nameLabel = UILabel().then {
        $0.text = "Please Search Beer by ID"
    }
    private let descLabel = UILabel().then {
        $0.text = ""
        $0.textColor = UIColor.gray
        $0.numberOfLines = 0
    }
    private let nameStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 10
    }
    //MARK: Initialization
    override func draw(_ rect: CGRect) {
        setupSubview()
    }
    //MARK: Public methods
    func setupView(model: Beer) {
        DispatchQueue.main.async {
            self.beerImageView.kf.setImage(with: URL(string: model.imageURL ?? ""))
            self.idLabel.text = model.id != nil ? String(model.id!) : ""
            self.nameLabel.text =  model.name ?? ""
            self.descLabel.text = model.description ?? ""
        }
    }
    // MARK: Private methods
    private func setupSubview() {
        addSubview(nameStackView)
        nameStackView.addArrangeSubviews([beerImageView, idLabel, nameLabel, descLabel])
        
        nameStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
