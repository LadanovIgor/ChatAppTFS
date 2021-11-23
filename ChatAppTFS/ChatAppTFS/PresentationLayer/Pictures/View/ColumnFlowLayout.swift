//
//  ColumnFlowLayout.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.11.2021.
//

import UIKit

class ColumnFlowLayout: UICollectionViewFlowLayout {

	let cellsPerRow: Int

	init(cellsPerRow: Int, minimumInteritemSpacing: CGFloat, minimumLineSpacing: CGFloat, sectionInset: UIEdgeInsets) {
		self.cellsPerRow = cellsPerRow
		super.init()
		self.minimumInteritemSpacing = minimumInteritemSpacing
		self.minimumLineSpacing = minimumLineSpacing
		self.sectionInset = sectionInset
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func prepare() {
		super.prepare()
		guard let collectionView = collectionView else { return }
		let interItemSpacing = minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
		let marginsAndInsets = sectionInset.left + sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + interItemSpacing
		let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
		itemSize = CGSize(width: itemWidth, height: itemWidth)
	}
}
