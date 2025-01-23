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
        bindActions()
    }
    
    override func onViewState(_ viewState: SignUpContext.ViewState) {
        switch viewState {
        case .initial:
            contentView.titleLabel.attributedText = viewModel.provideTitleText()
            contentView.subtitleLabel.attributedText = viewModel.provideSubtitleText()
        }
    }
    
    private func bindActions() {
        contentView.signUpWithEmailButton.touchUpInsidePublisher
            .sink { [weak self] in
                self?.viewModel.onViewEvent(.signUpWithEmailPressed)
            }
            .store(in: &cancelableSet)
        
        contentView.loginButton.touchUpInsidePublisher
            .sink { [weak self] in
                self?.viewModel.onViewEvent(.loginPressed)
            }
            .store(in: &cancelableSet)
    }
}
