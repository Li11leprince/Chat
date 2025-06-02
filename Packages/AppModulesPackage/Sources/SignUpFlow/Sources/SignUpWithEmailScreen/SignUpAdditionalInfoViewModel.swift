import UIKit
import Combine
import AppBaseFlow
import AppServices
import AppEntities

final class SignUpAdditionalInfoViewModel: BaseViewModel<SignUpAdditionalInfoContext.ViewEvent,
                                                       SignUpAdditionalInfoContext.ViewState,
                                                       SignUpAdditionalInfoContext.OutputEvent> {
    @Published var firstName: String = ""
    @Published var lastName: String?
    @Published var phone: String?
    @Published var bio: String?
    @Published var birthday: Date?
    @Published var avatar: UIImage?
    
    @Injected(\.accountHolder) private var accountHolder: AccountHolder
    @Injected(\.accountRepository) private var accountRepository: AccountRepository
    
    override func onViewEvent(_ event: SignUpAdditionalInfoContext.ViewEvent) {
        switch event {
        case .viewDidLoad:
            viewDidLoad()
        case .updateProfile:
            updateProfile()
        }
    }
    
    private func viewDidLoad() {
        viewState = .initial
    }
    
    private func updateProfile() {
        let id = accountHolder.account?.profile.id ?? UUID().uuidString
        let profile = UserProfile(
            id: id,
            phoneNumber: phone ?? "",
            firstName: firstName,
            lastName: lastName ?? "",
            displayName: "\(firstName) \(lastName)",
            bio: bio,
            birthday: birthday?.timeIntervalSince1970,
            avatar: nil
        )
        accountRepository.updateProfile(profile: profile)
            .sink { [weak self] result in
                switch result {
                case .success():
                    self?.outputEventSubject.send(.finish)
                case .failure(let error):
                    self?.viewState = .error(.defaultUIError(from: error))
                }
            }
            .store(in: &cancelableSet)
        viewState = .loading
    }
    
    func validateFirstName(name: String) -> Bool {
        return name.count >= GlobalConfig.FirstName.minСharacters &&
               name.count <= GlobalConfig.FirstName.maxСharacters
    }
    
    func validatePhone(phone: String) -> Bool {
        guard !phone.isEmpty else { return false }
        let phoneRegex = #"^\(\d{3}\) \d{3}-\d{4}$"#
        let regex = try? NSRegularExpression(pattern: phoneRegex)
        let range = NSRange(location: 0, length: phone.utf16.count)
        return regex?.firstMatch(in: phone, options: [], range: range) != nil
    }
} 
