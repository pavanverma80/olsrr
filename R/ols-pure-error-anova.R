#' @importFrom stats coefficients
#' @importFrom dplyr group_by_ select_ summarise_each funs
#' @title Lack of Fit F Test
#' @description Assess how much of the error in prediction is due to lack of model fit.
#' @param model an object of class \code{lm}
#' @param ... other parameters
#' @details The residual sum of squares resulting from a regression can be decomposed into 2 components:
#'
#' \itemize{
#'   \item Due to lack of fit
#'   \item Due to random variation
#' }
#'
#' If most of the error is due to lack of fit and not just random error, the model should be discarded and
#' a new model must be built. 
#'
#' @note The lack of fit F test works only with simple linear regression. Moreover, it is important that the 
#' data contains repeat observations i.e. replicates for at least one of the values of the predictor x. This 
#' test generally only applies to datasets with plenty of replicates.
#' @return \code{ols_pure_error_anova} returns an object of class
#' \code{"ols_pure_error_anova"}. An object of class \code{"ols_pure_error_anova"} is a
#' list containing the following components:
#'
#' \item{lackoffit}{f statistic}
#' \item{pure_error}{pure error}
#' \item{rss}{regression sum of squares}
#' \item{ess}{error sum of squares}
#' \item{total}{total sum of squares}
#' \item{rms}{}
#' \item{ems}{p-value of \code{fstat}}
#' \item{lms}{degrees of freedom}
#' \item{pms}{name(s) of \code{variable}}
#' \item{rf}{name of \code{group_var}}
#' \item{lf}{f statistic}
#' \item{pr}{p-value of \code{fstat}}
#' \item{pl}{degrees of freedom}
#' \item{mpred}{name(s) of \code{variable}}
#' \item{df_rss}{name of \code{group_var}}
#' \item{df_ess}{f statistic}
#' \item{df_lof}{p-value of \code{fstat}}
#' \item{df_error}{degrees of freedom}
#' \item{final}{name(s) of \code{variable}}
#' \item{resp}{name of \code{group_var}}
#' \item{preds}{name of \code{group_var}}
#' @references Kutner, MH, Nachtscheim CJ, Neter J and Li W., 2004, Applied Linear Statistical Models (5th edition). 
#' Chicago, IL., McGraw Hill/Irwin.
#' @examples
#' model <- lm(mpg ~ disp, data = mtcars)
#' ols_pure_error_anova(model)
#' @export
#'
ols_pure_error_anova <- function(model, ...) UseMethod('ols_pure_error_anova')

#' @export
#'
ols_pure_error_anova.default <- function(model, ...) {

	if (!all(class(model) == 'lm')) {
    stop('Please specify a OLS linear regression model.', call. = FALSE)
  }

	ln <- length(coefficients(model))
	if (ln > 2) {
		stop("Lack of fit F test is available only for simple linear regression.", call. = FALSE)
	}

	k <- peanova(model)
	result <- list( lackoffit = k$lackoffit,
		             pure_error = k$pure_error,
					              rss = k$rss,
					              ess = k$ess,
		             			total = k$total,
					              rms = k$rms,
					              ems = k$ems,
					              lms = k$lms,
					              pms = k$pms,
						             rf = k$rf,
						             lf = k$lf,
						             pr = k$pr,
						             pl = k$pl,
		                  mpred = k$mpred,
				             df_rss = k$df_rss,
				             df_ess = k$df_ess,
				             df_lof = k$df_lof,
		               df_error = k$df_error,
		                  final = k$final,
		                   resp = k$resp,
		                  preds = k$preds)

	class(result) <- 'ols_pure_error_anova'

	return(result)

}

#' @export
#'
print.ols_pure_error_anova <- function(x, ...) {
	print_pure_error_anova(x)
}
