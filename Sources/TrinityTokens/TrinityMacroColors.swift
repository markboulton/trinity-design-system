import SwiftUI

/// Functional colours that identify macronutrients (protein / carbs / fat) and
/// food-data quality. These are deliberately *not* theme-driven: a protein bar is
/// blue in every app, the way `TrinityStatusColors.success` is green everywhere.
///
/// Each macro has a `bar` colour (fills, backgrounds) and a darker `label` colour
/// (coloured letters in dense macro readouts such as "28P 56C 8F").
public enum TrinityMacroColors {

    // MARK: - Protein

    /// Protein bar / fill colour. Hex #378ADD.
    public static let macroProtein = Color(red: 0.216, green: 0.541, blue: 0.867)
    /// Protein label / text colour. Hex #0C447C.
    public static let macroProteinLabel = Color(red: 0.047, green: 0.267, blue: 0.486)

    // MARK: - Carbohydrate

    /// Carbohydrate bar / fill colour. Hex #EF9F27.
    public static let macroCarbs = Color(red: 0.937, green: 0.624, blue: 0.153)
    /// Carbohydrate label / text colour. Hex #854F0B.
    public static let macroCarbsLabel = Color(red: 0.522, green: 0.310, blue: 0.043)

    // MARK: - Fat

    /// Fat bar / fill colour. Hex #D85A30.
    public static let macroFat = Color(red: 0.847, green: 0.353, blue: 0.188)
    /// Fat label / text colour. Hex #993C1D.
    public static let macroFatLabel = Color(red: 0.600, green: 0.235, blue: 0.114)

    // MARK: - Food-data quality

    /// Verified food entry (full nutrition panel). Reuses the success green.
    public static let dataVerified = TrinityStatusColors.success
    /// Mostly-complete entry, missing some detail. Reuses the carbs amber.
    public static let dataPartial = macroCarbs
    /// Community-contributed, unverified entry. Reuses the fat coral.
    public static let dataCommunity = macroFat
}
