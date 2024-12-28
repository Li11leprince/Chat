//  

import UIKit
import AppBaseFlow

final class SignUpViewController: BaseViewController<SignUpViewModel,
                                  SignUpContext.ViewEvent,
                                  SignUpContext.ViewState,
                                  SignUpContext.ContentView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewEvent(.viewDidLoad)
    }
    
    override func onViewState(_ viewState: SignUpContext.ViewState) {
        switch viewState {
        case .initial:
            contentView.titleLabel.attributedText = viewModel.provideTitleText()
            contentView.subtitleLabel.attributedText = viewModel.provideSubtitleText()
        }
    }
}
