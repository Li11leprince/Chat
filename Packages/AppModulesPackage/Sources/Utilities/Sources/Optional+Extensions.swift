//  Copyright © 2021 My organization. All rights reserved.

import Foundation

extension Optional {

    public func ifValue<T>(_ perform: (Wrapped) -> T) -> T? {
        guard let value = self else { return nil }
        return perform(value)
    }
}
