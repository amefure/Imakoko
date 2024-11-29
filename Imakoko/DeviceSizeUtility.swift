//
//  DeviceSizeUtility.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/17.
//

import UIKit

class DeviceSizeUtility {
    static var deviceWidth: CGFloat {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return 0 }
        return window.screen.bounds.width
    }

    static var deviceHeight: CGFloat {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return 0 }
        return window.screen.bounds.height
    }

    static var isSESize: Bool {
        if deviceWidth < 400 {
            return true
        } else {
            return false
        }
    }

    static var isiPadSize: Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        } else {
            return false
        }
    }
}
