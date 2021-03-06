context("step_forward")

test_that('forward selection output matches the expected result', {

	model <- lm(y ~ x1 + x2 + x3 + x4, data = cement)
	k <- ols_step_forward(model)
	expect_equal(k$steps, 3)
	expect_equivalent(k$predictors, c("x4", "x1", "x2"))

})

test_that("forward selection fails when model inherits other than 'lm'", {
    y <- sample(c(1:4), 100, replace = T)
    x <- sample(c(1, 2), 100, replace = T)
    m <- glm(x ~ y)
    expect_error(ols_step_forward(m), 'Please specify a OLS linear regression model.')
})

test_that("forward selection fails when penter is not between 0 and 1", {
	model <- lm(y ~ x1 + x2 + x3 + x4, data = cement)
  expect_error(ols_step_forward(model, penter = -0.5), 'p value for entering variables into the model must be between 0 and 1.')
  expect_error(ols_step_forward(model, penter = 1.5), 'p value for entering variables into the model must be between 0 and 1.')
})

test_that("forward selection fails when model contains less than 2 predictors", {
	model <- lm(y ~ x1, data = cement)
  expect_error(ols_step_forward(model), 'Please specify a model with at least 2 predictors.')
})
