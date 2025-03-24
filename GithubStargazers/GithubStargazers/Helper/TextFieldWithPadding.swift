
import UIKit


/// UITextField with the padding, by default 10 from each side
final class TextFieldWithPadding: UITextField {
    
    var textPadding: UIEdgeInsets
    
    //MARK: Init
    init(textPadding: UIEdgeInsets = UIEdgeInsets(
        top: 10,
        left: 10,
        bottom: 10,
        right: 10
    )) {
        self.textPadding = textPadding
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
