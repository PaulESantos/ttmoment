#' @title Calculate community weighted mean, variance, skewness, and kurtosis
#' @description Calculates the community weighted mean, variance, skewness, and kurtosis of a given trait.
#'
#' @param trait_names Trait id column
#' @param comm_names Community names column
#' @param trait_value Trait values column
#' @param weight Column variable used to weight the trait values
#' @param df A data frame containing the trait and community data.
#'
#' @return Returns a data frame with the columns comm, trait, cwm, cwv, cws, and cwk.
#' @export
#'
#' @examples
#' df <- data.frame(trait = c("height", "height", "weight", "weight"),
#'                  trait_value = c(5, 10, 15, 12),
#'                  abundancia = c(1, 2, 1, 3),
#'                  comm = c("A", "A", "B", "B"))
#' tidy_calc_moment(df,
#' trait_names = trait,
#' comm_names = comm,
#' trait_value = trait_value,
#' weight = abundancia)
tidy_calc_moment  <- function(df, trait_names, comm_names, trait_value, weight) {
  # Calculate community weighted mean, variance, skewness, and kurtosis
  wm_trait <- df |>
    dplyr::group_by({{trait_names}}, {{comm_names}} ) |>
    dplyr::summarise(cwm = stats::weighted.mean({{trait_value}}, {{weight}},
                                                na.rm = TRUE),
                     cwv = sum(({{trait_value}} - cwm)^2 * {{weight}},
                               na.rm = TRUE)/ sum({{weight}}, na.rm = TRUE),
                     cws = sum((({{trait_value}} - cwm)/ sqrt(cwv))^3 * {{weight}},
                               na.rm = TRUE)/ sum({{weight}}, na.rm = TRUE),
                     cwk = (sum((({{trait_value}} - cwm)/sqrt(cwv))^4 * {{weight}},
                                na.rm = TRUE)/ sum({{weight}}, na.rm = TRUE)) - 3,
                     .groups = "drop"
    ) |>
    dplyr::distinct()
  class(wm_trait) <- c("tbl_df", "tbl", "data.frame")
  return(wm_trait)
}
