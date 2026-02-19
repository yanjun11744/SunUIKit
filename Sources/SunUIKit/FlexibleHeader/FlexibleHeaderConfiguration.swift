// FlexibleHeader/FlexibleHeaderConfiguration.swift

import SwiftUI

/// FlexibleHeader 的配置选项。
///
/// 将同一个实例同时传给 `.flexibleHeaderScrollView()` 和
/// `.flexibleHeaderContent()` 以保持行为一致。
///
/// ```swift
/// // 最简用法：不传参数，使用默认配置
/// .flexibleHeaderScrollView()
/// .flexibleHeaderContent()
///
/// // 自定义配置
/// let config = FlexibleHeaderConfiguration(
///     baseHeight: .fixed(260),
///     maximumHeight: 480
/// )
/// .flexibleHeaderScrollView(configuration: config)
/// .flexibleHeaderContent(configuration: config)
/// ```
public struct FlexibleHeaderConfiguration: Sendable {

    // MARK: - 高度

    /// 静止时头部的基准高度，默认为容器高度的一半。
    public var baseHeight: BaseHeight

    /// 下拉拉伸的最大高度限制，`nil` 表示不限制。
    public var maximumHeight: CGFloat?

    /// 正常向上滚动时头部的最小高度限制，`nil` 表示不限制。
    public var minimumHeight: CGFloat?

    // MARK: - 回调

    /// 拉伸进度回调，仅在用户下拉超出顶部时触发。
    /// - 0.0：静止状态
    /// - 1.0：拉伸到 `maximumHeight`（需设置才有意义）
    public var onStretchProgress: (@Sendable (CGFloat) -> Void)?

    // MARK: - Init

    public init(
        baseHeight: BaseHeight = .halfContainer,
        maximumHeight: CGFloat? = nil,
        minimumHeight: CGFloat? = nil,
        onStretchProgress: ((CGFloat) -> Void)? = nil
    ) {
        self.baseHeight = baseHeight
        self.maximumHeight = maximumHeight
        self.minimumHeight = minimumHeight
        self.onStretchProgress = onStretchProgress
    }

    // MARK: - BaseHeight

    /// 头部基准高度的计算方式。
    public enum BaseHeight {
        /// 容器高度 / 2（默认行为）
        case halfContainer
        /// 固定像素值
        case fixed(CGFloat)

        func resolve(containerHeight: CGFloat) -> CGFloat {
            switch self {
            case .halfContainer: return containerHeight / 2
            case .fixed(let h):  return h
            }
        }
    }
}

// MARK: - 默认值 & 预设

public extension FlexibleHeaderConfiguration {

    /// 默认配置：基准高度为容器一半，无限制，无回调。
    static let `default` = FlexibleHeaderConfiguration()

    /// 限制最大拉伸高度的便捷预设。
    static func clamped(
        baseHeight: BaseHeight = .halfContainer,
        max maximumHeight: CGFloat,
        onProgress: ((CGFloat) -> Void)? = nil
    ) -> Self {
        FlexibleHeaderConfiguration(
            baseHeight: baseHeight,
            maximumHeight: maximumHeight,
            onStretchProgress: onProgress
        )
    }
}