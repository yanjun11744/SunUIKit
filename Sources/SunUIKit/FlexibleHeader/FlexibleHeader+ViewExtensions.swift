// FlexibleHeader/FlexibleHeader+ViewExtensions.swift

import SwiftUI

// MARK: - ScrollView

public extension ScrollView {

    /// 为 ScrollView 启用弹性拉伸头部功能。
    ///
    /// 搭配头部视图上的 `.flexibleHeaderContent()` 使用：
    ///
    /// ```swift
    /// ScrollView {
    ///     HeroView()
    ///         .flexibleHeaderContent()
    ///     // 其他内容...
    /// }
    /// .flexibleHeaderScrollView()
    /// .ignoresSafeArea(edges: .top)
    /// ```
    ///
    /// - Parameter configuration: 配置项，默认使用 `.default`。
    @MainActor
    func flexibleHeaderScrollView(
        configuration: FlexibleHeaderConfiguration = .default
    ) -> some View {
        modifier(FlexibleHeaderScrollViewModifier(configuration: configuration))
    }
}

// MARK: - Header View

public extension View {

    /// 将弹性拉伸效果应用到头部视图。
    ///
    /// - Parameter configuration: 须与 `.flexibleHeaderScrollView()` 传入的实例一致。
    func flexibleHeaderContent(
        configuration: FlexibleHeaderConfiguration = .default
    ) -> some View {
        modifier(FlexibleHeaderContentModifier(configuration: configuration))
    }
}