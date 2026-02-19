// FlexibleHeader/FlexibleHeaderGeometry.swift

import SwiftUI

/// 内部模型：存储当前滚动超出顶部边界的偏移量。
/// 正常滚动时为 0，用户向下拉超出顶部时为负值。
@Observable
final class FlexibleHeaderGeometry {
    var offset: CGFloat = 0
}