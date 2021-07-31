//
//  Constants.swift
//  Artable
//
//  Created by Nikhil Gharge on 13/11/19.
//  Copyright © 2019 Nikhil Gharge. All rights reserved.
//

import Foundation
import UIKit

struct StoryBoard {
    static let LoginStoryBoard = "LoginStoryboard"
}

struct StoryBoardId {
    static let LoginVC = "loginVC"
}

struct AppImages {
    static let GreenCheck = "green_check"
    static let redCheck = "red_check"
    static let FilledStar = "filled_star"
    static let EmptyStar = "empty_star"
}

struct AppColors {
    static let blue = #colorLiteral(red: 0, green: 0.5718719363, blue: 1, alpha: 1)
    static let red = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    static let OffWhite = #colorLiteral(red: 0.9625874162, green: 0.9638113379, blue: 1, alpha: 1)
}

struct Identifiers {
    static let CategoryCell = "CategoryCell"
    static let ProductCell = "ProductCell"
    static let cartCell = "CartTableCell"
}

struct Segues{
    static let toEditCategory = "toEditCategory"
    static let toAddEditProduct = "toAddEditProduct"
    static let ToFavourites = "ToFavourites"
}
