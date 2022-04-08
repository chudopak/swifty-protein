//
//  ViewModelConfigurable.swift
//  StartProject-ios
//
//  Created by Rustam Nurgaliev on 13.03.2021.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

/// Определяет возможность настройки представления
public protocol ViewModelConfigurable where Self: UIView {
    associatedtype ViewModel

    /// Настраивает отображение
    ///
    /// - Parameter viewModel: Модель представления для конфигурации
    func configure(with viewModel: ViewModel)
}
