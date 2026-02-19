// FlexibleHeader/FlexibleHeaderGeometry.swift

import SwiftUI

/// 内部模型：存储滚动状态和容器尺寸。
/// - offset: 正常滚动时为 0，用户向下拉超出顶部时为负值。
/// - containerHeight: ScrollView 的容器高度，由 FlexibleHeaderScrollViewModifier 写入。
@Observable
final class FlexibleHeaderGeometry {
    var offset: CGFloat = 0
    var containerHeight: CGFloat = 0
}