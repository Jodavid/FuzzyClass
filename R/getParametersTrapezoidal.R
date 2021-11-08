# --------------------------------------------------
#             Fuzzy Naive Bayes Trapeizodal
#
# data: 18.09.2021
# version: 0.1
# author: Arthur..., Ronei Moraes
# adaptado por: Jodavid Ferreira;
# e-mails: ...,jodavid@protonmail.com; ronei@de.ufpb.br
#
# --------------------------------------------------

getParametersTrapezoidal <- function(sample) {
  # -------------------------
  # sample length
  n <- length(sample)
  # -------------------------
  # min value
  minimum <- min(sample)
  # -------------------------
  # max value
  maximum <- max(sample)
  variance <- var(sample)
  m <- expected <- median.default(sample)
  # -------------------------
  model <- function(x) {
    # ----------
    # Expected value
    F1 <- ((-minimum * x[1] - x[1]^2 + maximum * x[2] + x[2]^2 + maximum^2 - minimum^2) /
      (3 * x[2] - 3 * x[1] + 3 * maximum - 3 * minimum)) - expected
    # ----------
    # Variance Value
    F2 <- (((6 * (x[2] - x[1])^4 + 12 * ((x[1] - minimum) + (maximum - x[2])) *
      (x[2] - x[1])^3 + (12 * ((x[1] - minimum) + (maximum - x[2]))^2 - 6 * (x[1] - minimum) * (maximum - x[2])) * (x[2] - x[1])^2) / (18 * ((x[1] - minimum) + 2 * (x[2] - x[1]) + (maximum - x[2]))^2)) +
      ((6 * ((x[1] - minimum) + (maximum - x[2])) * ((x[1] - minimum)^2 + (x[1] - minimum) * (maximum - x[2]) + (maximum - x[2])^2) * (x[2] - x[1]) +
        ((x[1] - minimum) + (maximum - x[2]))^2 * ((x[1] - minimum)^2 + (x[1] - minimum) * (maximum - x[2]) + (maximum - x[2])^2)) / (18 * ((x[1] - minimum) + 2 * (x[2] - x[1]) + (maximum - x[2]))^2))) - variance
    # -------------------------
    # Return
    return(c(F1 = F1, F2 = F2))
    # -------------------------
  }
  # -------------------------
  # midpoint
  pmedio <- minimum + ((maximum - minimum) / 2)
  # --------
  ss <- rootSolve::multiroot(f = model, start = c(pmedio, pmedio + .1))
  ss <- c(ss$root[1], ss$root[2])
  # --------
  if (ss[1] > ss[2]) {
    # --------
    topo1 <- ss[2]
    topo2 <- ss[1]
    # --------
  } else {
    # --------
    topo1 <- ss[1]
    topo2 <- ss[2]
    # --------
  }
  # -------------------------
  # Verificando limites
  topo1 <- ifelse(topo1 < minimum, minimum, topo1)
  # ---
  topo2 <- ifelse(topo2 <= topo1, topo1,
    ifelse(topo2 >= maximum, maximum, topo2)
  )
  # -------------------------
  # Parameters Return
  return(c(minimum, topo1, topo2, maximum))
}
