# Fit an extended heteroscedastic Deming regression

Fits the slope and intrinsic scatter in a heteroscedastic
errors-in-variables model using full-likelihood estimation. Supports
analytical or numerical gradient optimization.

## Usage

``` r
fit_demingx(data, use_grad = TRUE, start = NULL)
```

## Arguments

- data:

  Data frame with columns `x_obs`, `y_obs`, `s_x`, `s_y`.

- use_grad:

  Logical; whether to use analytical gradients.

- start:

  Optional numeric vector of starting values (beta, log_sigma_eta2).

## Value

A list of class `demingx` containing parameter estimates,
log-likelihood, convergence information, and call.

## Examples

``` r
dat <- simulate_demingx(200, beta = 2, sigma_eta = 0.3)
fit <- fit_demingx(dat)
print(fit)
#> Extended Heteroscedastic Deming Fit
#>   beta       = 2.0776
#>   sigma_eta^2 = 0.0061
#>   logLik     = -219.83
#>   convergence code: 0
```
