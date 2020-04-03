import UIKit

extension UIView {

    func constraintToParent(constant: CGFloat = 0) {
        guard let parent = superview else { fatalError() }

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parent.topAnchor, constant: constant),
            bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -constant),
            leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: constant),
            trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -constant)
        ])

    }
}
