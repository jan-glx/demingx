# Vectorized log-likelihood for the extended Deming model

Computes the full log-likelihood for the heteroscedastic slope-only
errors-in-variables model. Optionally includes analytical gradient
computation for optimization.

## Usage

``` r
demingx_loglik(par, data, compute_grad = TRUE)
```

## Arguments

- par:

  Numeric vector of parameters: (beta, log_sigma_eta2).

- data:

  Data frame with columns `x_obs`, `y_obs`, `s_x`, `s_y`.

- compute_grad:

  Logical; whether to compute and attach analytical gradients.

## Value

The log-likelihood value (scalar). If `compute_grad = TRUE`, the result
has an attribute `gradient` containing analytical partial derivatives.

## Examples

``` r
dat <- simulate_demingx(100, 2, 0.3)
par <- c(1.5, log(0.3^2))
demingx_loglik(par, dat)
#> [1] -141.8924
#> attr(,"gradient")
#> [1] 80.832158  4.222016
```
