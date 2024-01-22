//
//  BeerTableViewCell.swift
//  BeerList-MVVM
//
//  Created by MacBook on 22.01.2024.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class BeerTableViewCell: UITableViewCell {
    private let beerImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.snp.makeConstraints {
            $0.height.width.equalTo(100)
        }
    }
    private let idLabel = UILabel().then {
        $0.textColor = UIColor.orange
        $0.text = "ID"
        $0.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    }
    private let nameLabel = UILabel().then {
        $0.text = "User Name"
    }
    private let descLabel = UILabel().then {
        $0.text = "Description"
        $0.textColor = UIColor.gray
        $0.numberOfLines = 3
    }
    private let nameStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .top
    }
    private let mainStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 10
    }
    //MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubview()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    //MARK: Public methods
    func setupView(model: Beer) {
        DispatchQueue.main.async {
            self.beerImageView.kf.setImage(with: URL(string: model.imageURL ?? ""))
            self.idLabel.text = String(model.id ?? 0)
            self.nameLabel.text =  model.name ?? ""
            self.descLabel.text = model.description ?? ""
        }
    }
    //MARK: Private methods
    private func setupSubview() {
        addSubview(mainStackView)
        nameStackView.addArrangeSubviews([idLabel, nameLabel, descLabel])
        mainStackView.addArrangeSubviews([beerImageView, nameStackView])
        
        mainStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16).priority(.high)
        }
    }
}
