#' Fit an extended heteroscedastic Deming regression
#'
#' @description
#
#
#' Fits the slope and intrinsic scatter in a heteroscedastic errors-in-variables model
#' using full-likelihood estimation. Supports analytical or numerical gradient optimization.
#'
#' @param data Data frame with columns `x_obs`, `y_obs`, `s_x`, `s_y`.
#' @param use_grad Logical; whether to use analytical gradients.
#' @param start Optional numeric vector of starting values (beta, log_sigma_eta2).
#' @return A list of class `demingx` containing parameter estimates, log-likelihood,
#' convergence information, and call.
#' @examples
#' dat <- simulate_demingx(200, beta = 2, sigma_eta = 0.3)
#' fit <- fit_demingx(dat)
#' print(fit)
#
#
#
#' @importFrom stats optim rnorm rlnorm var
#' @export
fit_demingx <- function(data, use_grad = TRUE, start = NULL) {
  if (is.null(start)) start <- c(1, log(var(data$y_obs)))

  fn <- function(par) {
    val <- -demingx_loglik(par, data, compute_grad = use_grad)
    if (use_grad) attr(val, 'gradient') <- -attr(val, 'gradient')
    val
  }

  opt <- optim(start, fn, method = 'BFGS', hessian = TRUE)
  res <- list(
    par = opt$par,
    beta = opt$par[1],
    sigma_eta2 = exp(opt$par[2]),
    logLik = -opt$value,
    convergence = opt$convergence,
    hessian = opt$hessian,
    call = match.call()
  )
  class(res) <- 'demingx'
  res
}

#
#
#
#' @importFrom stats optim rnorm rlnorm var
#' @export
print.demingx <- function(x, ...) {
  cat('Extended Heteroscedastic Deming Fit\n')
  cat(sprintf('  beta       = %.4f\n', x$beta))
  cat(sprintf('  sigma_eta^2 = %.4f\n', x$sigma_eta2))
  cat(sprintf('  logLik     = %.2f\n', x$logLik))
  cat(sprintf('  convergence code: %d\n', x$convergence))
  invisible(x)
}

#
#
#
#' @importFrom stats optim rnorm rlnorm var
#' @export
coef.demingx <- function(object, ...) {
  c(beta = object$beta, sigma_eta2 = object$sigma_eta2)
}

#
#
#
#' @importFrom stats optim rnorm rlnorm var
#' @export
logLik.demingx <- function(object, ...) {
  val <- structure(object$logLik, df = 2L, class = 'logLik')
  val
}
