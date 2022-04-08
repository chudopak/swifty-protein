//
//  Grid.swift
//  sibur-umsh
//
//  Created by Anton on 18/01/2019.
//

import UIKit

/// Протокол определяющий сетку по которой верстаются визуальный компоненты
/// Опередление кастомных размеров в Appearance допускается только в исключительных случаях
///
/// Пример:
/// extension MyModuleView {
///     struct Appearance: Grid { }
/// }
///
/// class MyModuleView: UIView {
///     let appearance = Appearance()
///     lazy var subview = UIView()
///
///     private func makeConstraints() {
///         subview.snp.makeConstraints { (make) in
///             make.top.left.right.equalToSuperview().inset(appearance.xxlInsets)
///             make.height.equalTo(appearance.xxlSize)
///             make.top.equalTo(previousSubview.snp.bottom).inset(appearance.xxsSpace)
///         }
///     }
/// }
public protocol Grid {
    /// Размер минимального элемента сетки
    static var gridUnitSize: CGSize { get }
}

// MARK: - Cетки для верстки по умолчанию

public extension Grid {
    /// Значение минимального размера сетки по умолчанию
    static var gridUnitSize: CGSize { return CGSize(4) }
    
    // MARK: Grid multipliers
    
    /// = 1
    static var xxxs: CGFloat { return 1 }
    /// = 2
    static var xxs: CGFloat { return 2 }
    /// = 3
    static var xs: CGFloat { return 3 }
    /// = 4
    static var s: CGFloat { return 4 }
    /// = 6
    static var m: CGFloat { return 6 }
    /// = 8
    static var l: CGFloat { return 8 }
    /// = 9
    static var xl: CGFloat { return 9 }
    /// = 12
    static var xxl: CGFloat { return 12 }
    /// = 18
    static var xxxl: CGFloat { return 18 }
    
    /// {4, 4, 4, 4},  если gridUnitSize не переопределён
    var xxxsInsets: UIEdgeInsets { return UIEdgeInsets(Self.gridUnitSize) * Self.xxxs }
    /// {8, 8, 8, 8},  если gridUnitSize не переопределён
    var xxsInsets: UIEdgeInsets { return UIEdgeInsets(Self.gridUnitSize) * Self.xxs }
    /// {12, 12, 12, 12},  если gridUnitSize не переопределён
    var xsInsets: UIEdgeInsets { return UIEdgeInsets(Self.gridUnitSize) * Self.xs }
    /// {16, 16, 16, 16},  если gridUnitSize не переопределён
    var sInsets: UIEdgeInsets { return UIEdgeInsets(Self.gridUnitSize) * Self.s }
    /// {24, 24, 24, 24},  если gridUnitSize не переопределён
    var mInsets: UIEdgeInsets { return UIEdgeInsets(Self.gridUnitSize) * Self.m }
    /// {32, 32, 32, 32},  если gridUnitSize не переопределён
    var lInsets: UIEdgeInsets { return UIEdgeInsets(Self.gridUnitSize) * Self.l }
    /// {36, 36, 36, 36},  если gridUnitSize не переопределён
    var xlInsets: UIEdgeInsets { return UIEdgeInsets(Self.gridUnitSize) * Self.xl }
    /// {48, 48, 48, 48},  если gridUnitSize не переопределён
    var xxlInsets: UIEdgeInsets { return UIEdgeInsets(Self.gridUnitSize) * Self.xxl }
    /// {72, 72, 72, 72},  если gridUnitSize не переопределён
    var xxxlInsets: UIEdgeInsets { return UIEdgeInsets(Self.gridUnitSize) * Self.xxxl }
    
    /// = 4,  если gridUnitSize не переопределён
    var xxxsSpace: CGFloat { return Self.gridUnitSize.height * CGFloat(Self.xxxs) }
    /// = 8,  если gridUnitSize не переопределён
    var xxsSpace: CGFloat { return Self.gridUnitSize.height * CGFloat(Self.xxs) }
    /// = 12,  если gridUnitSize не переопределён
    var xsSpace: CGFloat { return Self.gridUnitSize.height * CGFloat(Self.xs) }
    /// = 16,  если gridUnitSize не переопределён
    var sSpace: CGFloat { return Self.gridUnitSize.height * CGFloat(Self.s) }
    /// = 24,  если gridUnitSize не переопределён
    var mSpace: CGFloat { return Self.gridUnitSize.height * CGFloat(Self.m) }
    /// = 32,  если gridUnitSize не переопределён
    var lSpace: CGFloat { return Self.gridUnitSize.height * CGFloat(Self.l) }
    /// = 36,  если gridUnitSize не переопределён
    var xlSpace: CGFloat { return Self.gridUnitSize.height * CGFloat(Self.xl) }
    /// = 48,  если gridUnitSize не переопределён
    var xxlSpace: CGFloat { return Self.gridUnitSize.height * CGFloat(Self.xxl) }
    /// = 72,  если gridUnitSize не переопределён
    var xxxlSpace: CGFloat { return Self.gridUnitSize.height * CGFloat(Self.xxxl) }
    
    /// {4, 4},  если gridUnitSize не переопределён
    var xxxsSize: CGSize { return Self.gridUnitSize * Self.xxxs }
    /// {8, 8},  если gridUnitSize не переопределён
    var xxsSize: CGSize { return Self.gridUnitSize * Self.xxs }
    /// {12, 12},  если gridUnitSize не переопределён
    var xsSize: CGSize { return Self.gridUnitSize * Self.xs }
    /// {16, 16},  если gridUnitSize не переопределён
    var sSize: CGSize { return Self.gridUnitSize * Self.s }
    /// {24, 24},  если gridUnitSize не переопределён
    var mSize: CGSize { return Self.gridUnitSize * Self.m }
    /// {32, 32},  если gridUnitSize не переопределён
    var lSize: CGSize { return Self.gridUnitSize * Self.l }
    /// {36, 36},  если gridUnitSize не переопределён
    var xlSize: CGSize { return Self.gridUnitSize * Self.xl }
    /// {48, 48},  если gridUnitSize не переопределён
    var xxlSize: CGSize { return Self.gridUnitSize * Self.xxl }
    /// {72, 72},  если gridUnitSize не переопределён
    var xxxlSize: CGSize { return Self.gridUnitSize * Self.xxxl }
    
    /// {4, 4},  если gridUnitSize не переопределён
    var xxxsOffset: UIOffset { return UIOffset(Self.gridUnitSize) * Self.xxxs }
    /// {8, 8},  если gridUnitSize не переопределён
    var xxsOffset: UIOffset { return UIOffset(Self.gridUnitSize) * Self.xxs }
    /// {12, 12},  если gridUnitSize не переопределён
    var xsOffset: UIOffset { return UIOffset(Self.gridUnitSize) * Self.xs }
    /// {16, 16},  если gridUnitSize не переопределён
    var sOffset: UIOffset { return UIOffset(Self.gridUnitSize) * Self.s }
    /// {24, 24},  если gridUnitSize не переопределён
    var mOffset: UIOffset { return UIOffset(Self.gridUnitSize) * Self.m }
    /// {32, 32},  если gridUnitSize не переопределён
    var lOffset: UIOffset { return UIOffset(Self.gridUnitSize) * Self.l }
    /// {36, 36},  если gridUnitSize не переопределён
    var xlOffset: UIOffset { return UIOffset(Self.gridUnitSize) * Self.xl }
    /// {48, 48},  если gridUnitSize не переопределён
    var xxlOffset: UIOffset { return UIOffset(Self.gridUnitSize) * Self.xxl }
    /// {72, 72},  если gridUnitSize не переопределён
    var xxxlOffset: UIOffset { return UIOffset(Self.gridUnitSize) * Self.xxxl }
    
    /// Размер пикселя, в зависимости от scale экрана
    var pixelSize: CGFloat { return 1 / UIScreen.main.scale }
}

public extension CGSize {
    /// Инициализирует струтуру с идентичными размерами по высоте и ширине, равными входящему параметру
    ///
    /// - Parameter size: размер с которым нужно инициализировать структуру
    init(_ size: CGFloat) {
        self.init(width: size, height: size)
    }
    
    /// Умножает все элементы структуры на множитель
    ///
    /// - Parameters:
    ///   - lhs: исходная структура CGSize
    ///   - rhs: множитель
    /// - Returns: результат умножения всех элементов на множитель
    static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
}

extension UIOffset {
    /// Инициализирует структуру с отсутапми равными ширине и высоте входящего параметра
    ///
    /// - Parameter size: размер с которым нужно инициализировать структуру
    init(_ size: CGSize) {
        self.init(horizontal: size.width, vertical: size.height)
    }
    
    /// Умножает все элементы структуры на множитель
    ///
    /// - Parameters:
    ///   - lhs: исходная структура UIOffset
    ///   - rhs: множитель
    /// - Returns: результат умножения всех элементов на множитель
    static func * (lhs: UIOffset, rhs: CGFloat) -> UIOffset {
        return UIOffset(horizontal: lhs.horizontal * rhs, vertical: lhs.vertical * rhs)
    }
}

public extension UIEdgeInsets {
    /// Инициализирует структуру с попарно одинаковыми отсутапми, сверху и снизу равными высоте, слева и справа — ширине
    ///
    /// - Parameter size: высота и ширина отступов
    init(_ size: CGSize) {
        self.init(top: size.height, left: size.width, bottom: size.height, right: size.width)
    }
    
    /// Умножает все элементы структуры на множитель
    ///
    /// - Parameters:
    ///   - lhs: исходная структура UIEdgeInsets
    ///   - rhs: множитель
    /// - Returns: результат умножения всех элементов на множитель
    static func * (lhs: UIEdgeInsets, rhs: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: lhs.top * rhs, left: lhs.left * rhs, bottom: lhs.bottom * rhs, right: lhs.right * rhs)
    }
    
    /// Инициализирует структуру с заданными вертикальными и горизонтальными отступами
    init(vertical: CGFloat = 0, horizontal: CGFloat = 0) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    
    /// Инициализирует структуру с равными по всем сторонам отступами
    init(uniform: CGFloat) {
        self.init(top: uniform, left: uniform, bottom: uniform, right: uniform)
    }
    
    /// Возвращает новую структуру с заданным отступом сверху
    func with(top: CGFloat) -> UIEdgeInsets {
        var inset = self
        inset.top = top
        return inset
    }
    
    /// Возвращает новую структуру с заданным отступом слева
    func with(left: CGFloat) -> UIEdgeInsets {
        var inset = self
        inset.left = left
        return inset
    }
    
    /// Возвращает новую структуру с заданным отступом снизу
    func with(bottom: CGFloat) -> UIEdgeInsets {
        var inset = self
        inset.bottom = bottom
        return inset
    }
    
    /// Возвращает новую структуру с заданным отступом справа
    func with(right: CGFloat) -> UIEdgeInsets {
        var inset = self
        inset.right = right
        return inset
    }
    
    /// Возвращает новую структуру с нулевым верхним отступом
    func withoutTop() -> UIEdgeInsets { return with(top: 0) }
    
    /// Возвращает новую структуру с нулевым левым отступом
    func withoutLeft() -> UIEdgeInsets { return with(left: 0) }
    
    /// Возвращает новую структуру с нулевым нижним отступом
    func withoutBottom() -> UIEdgeInsets { return with(bottom: 0) }
    
    /// Возвращает новую структуру с нулевым правым отступом
    func withoutRight() -> UIEdgeInsets { return with(right: 0) }
}
