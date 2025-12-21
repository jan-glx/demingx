#' Vectorized log-likelihood for the extended Deming model
#'
#' @description
#
#
#' Computes the full log-likelihood for the heteroscedastic slope-only errors-in-variables model.
#' Optionally includes analytical gradient computation for optimization.
#'
#' @param par Numeric vector of parameters: (beta, log_sigma_eta2).
#' @param data Data frame with columns `x_obs`, `y_obs`, `s_x`, `s_y`.
#' @param compute_grad Logical; whether to compute and attach analytical gradients.
#' @return The log-likelihood value (scalar). If `compute_grad = TRUE`, the result has an attribute
#' `gradient` containing analytical partial derivatives.
#' @examples
#' dat <- simulate_demingx(100, 2, 0.3)
#' par <- c(1.5, log(0.3^2))
#' demingx_loglik(par, dat)
#
#
#' @export
demingx_loglik <- function(par, data, compute_grad = TRUE) {
  beta <- par[1]
  sigma_eta2 <- exp(par[2])
  x <- data$x_obs; y <- data$y_obs
  sx2 <- data$s_x^2; sy2 <- data$s_y^2
  n <- length(x)

  a11 <- 1 + sx2
  a12 <- rep(beta, n)
  a22 <- beta^2 + sigma_eta2 + sy2
  detS <- a11 * a22 - a12^2

  Sinv11 <-  a22 / detS
  Sinv22 <-  a11 / detS
  Sinv12 <- -a12 / detS

  q <- Sinv11 * x^2 + 2 * Sinv12 * x * y + Sinv22 * y^2
  ll <- -0.5 * sum(log(detS) + q)

  if (!compute_grad) {
    attr(ll, 'gradient') <- NULL
    return(ll)
  }

  # Derivatives wrt beta and sigma_eta2
  dS_db_11 <- rep(0, n)
  dS_db_12 <- rep(1, n)
  dS_db_22 <- 2 * beta
  dS_ds_11 <- rep(0, n)
  dS_ds_12 <- rep(0, n)
  dS_ds_22 <- rep(1, n)

  trA_db <- Sinv11 * dS_db_11 + 2 * Sinv12 * dS_db_12 + Sinv22 * dS_db_22
  trA_ds <- Sinv11 * dS_ds_11 + 2 * Sinv12 * dS_ds_12 + Sinv22 * dS_ds_22

  Ax <- Sinv11 * x + Sinv12 * y
  Ay <- Sinv12 * x + Sinv22 * y

  tmp_db <- dS_db_11 * Ax^2 + 2 * dS_db_12 * Ax * Ay + dS_db_22 * Ay^2
  tmp_ds <- dS_ds_11 * Ax^2 + 2 * dS_ds_12 * Ax * Ay + dS_ds_22 * Ay^2

  grad_beta <- 0.5 * sum(tmp_db - trA_db)
  grad_sigma <- 0.5 * sum(tmp_ds - trA_ds) * sigma_eta2

  attr(ll, 'gradient') <- c(grad_beta, grad_sigma)
  ll
}
