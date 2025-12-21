#' Simulate data for an extended heteroscedastic Deming regression
#'
#' @description
#
#
#' Generates synthetic data for the heteroscedastic slope-only errors-in-variables model
#' with per-observation known standard errors for both x and y.
#'
#' @param n Number of observations.
#' @param beta True slope parameter.
#' @param sigma_eta Intrinsic scatter (standard deviation of y_true conditional on x_true).
#' @param mu_x,mu_y,tau_x,tau_y Parameters of lognormal distributions used to draw s_x and s_y.
#' @return A data frame with columns `x_obs`, `y_obs`, `s_x`, `s_y`.
#' @examples
#' dat <- simulate_demingx(100, beta = 2, sigma_eta = 0.3)
#' head(dat)
#
#
#
#' @importFrom stats optim rnorm rlnorm var
#' @export
simulate_demingx <- function(n, beta, sigma_eta = 0.3,
                             mu_x = -0.7, tau_x = 0.3, mu_y = -0.7, tau_y = 0.3) {
  x_true <- rnorm(n, 0, 1)
  eta <- rnorm(n, 0, sigma_eta)
  y_true <- beta * x_true + eta
  s_x <- rlnorm(n, mu_x, tau_x)
  s_y <- rlnorm(n, mu_y, tau_y)
  x_obs <- x_true + rnorm(n, 0, s_x)
  y_obs <- y_true + rnorm(n, 0, s_y)
  data.frame(x_obs, y_obs, s_x, s_y)
}
