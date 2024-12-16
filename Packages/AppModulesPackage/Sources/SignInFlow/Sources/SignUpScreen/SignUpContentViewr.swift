//  

import AppBaseFlow

extension SignUpContext {
    
    final class ContentView: BaseView {
        private lazy var chatLogoImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "chatLogo")
            return imageView
        }()
        override func setLayout() {
            print("f")
        }
    }
}
