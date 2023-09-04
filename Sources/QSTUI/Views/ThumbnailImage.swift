//
//  ThumbnailImage.swift
//  QSTUI
//
//  Created by Huy Nguyen on 01/09/2023.
//

import SwiftUI
import QST

struct ThumbnailImage: View {

    let imageNamed: String
    let size: ThumbnailSize

    var body: some View {
        Image(imageNamed)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size.width)
            .cornerRadius(4)
            .shadow(radius: 8.0)
    }
}

#if DEBUG
struct ThumbnailImage_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailImage(imageNamed: Store.mock.makeMockMovie().thumbnail, size: .list)
    }
}
#endif

enum ThumbnailSize {
    case list, details

    var width: CGFloat {
        switch self {
        case .list: return 96.0
        case .details: return 128.0
        }
    }
}
