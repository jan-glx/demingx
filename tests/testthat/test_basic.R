library(testthat)
library(demingx)

test_that('simulation produces correct structure', {
  dat <- simulate_demingx(10, 2)
  expect_true(all(c('x_obs', 'y_obs', 's_x', 's_y') %in% names(dat)))
  expect_equal(nrow(dat), 10)
})

test_that('loglik runs and gradient matches numerical approx', {
  dat <- simulate_demingx(50, 2, 0.3)
  par <- c(1.8, log(0.3^2))
  ll1 <- demingx_loglik(par, dat, TRUE)
  numgrad <- numDeriv::grad(function(p) demingx_loglik(p, dat, FALSE), par)
  anagrad <- attr(ll1, 'gradient')
  expect_equal(anagrad, numgrad, tolerance = 1e-2)
})

test_that('fit_demingx recovers parameters approximately', {
  set.seed(123)
  dat <- simulate_demingx(300, 2, 0.3)
  fit <- fit_demingx(dat)
  expect_true(abs(fit$beta - 2) < 0.2)
  expect_true(abs(sqrt(fit$sigma_eta2) - 0.3) < 0.15)
})
