# Simulate data for an extended heteroscedastic Deming regression

Generates synthetic data for the heteroscedastic slope-only
errors-in-variables model with per-observation known standard errors for
both x and y.

## Usage

``` r
simulate_demingx(
  n,
  beta,
  sigma_eta = 0.3,
  mu_x = -0.7,
  tau_x = 0.3,
  mu_y = -0.7,
  tau_y = 0.3
)
```

## Arguments

- n:

  Number of observations.

- beta:

  True slope parameter.

- sigma_eta:

  Intrinsic scatter (standard deviation of y_true conditional on
  x_true).

- mu_x, mu_y, tau_x, tau_y:

  Parameters of lognormal distributions used to draw s_x and s_y.

## Value

A data frame with columns `x_obs`, `y_obs`, `s_x`, `s_y`.

## Examples

``` r
dat <- simulate_demingx(100, beta = 2, sigma_eta = 0.3)
head(dat)
#>         x_obs      y_obs       s_x       s_y
#> 1 -0.67485862  0.5013246 0.4235063 0.4465746
#> 2  1.05045619  1.0939034 0.4536517 0.3587795
#> 3 -0.53620420 -0.5241766 0.4144966 0.6636883
#> 4  0.67666704  2.9751674 0.4513725 0.4299187
#> 5  0.03240968  0.5787555 0.5446885 0.3633783
#> 6 -1.73758621 -2.5005859 0.6310280 0.5272339
```
