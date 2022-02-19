#' Fuzzy Naive Bayes
#'
#' \code{FuzzyNaiveBayes} Fuzzy Naive Bayes
#'
#'
#' @param train matrix or data frame of training set cases.
#' @param cl factor of true classifications of training set
#' @param fuzzy boolean variable to use the membership function
#' @param m is M/N, where M is the number of classes and N is the number of train lines
#' @param Pi is 1/M, where M is the number of classes
#'
#' @return A vector of classifications
#'
#' @references
#' \insertRef{moraes2009another}{FuzzyClass}
#'
#' @examples
#'
#' set.seed(1) # determining a seed
#' data(HouseVotes84, package = "mlbench")
#'
#' # Splitting into Training and Testing
#' split <- caTools::sample.split(t(HouseVotes84[, 1]), SplitRatio = 0.7)
#' Train <- subset(HouseVotes84, split == "TRUE")
#' Test <- subset(HouseVotes84, split == "FALSE")
#' # ----------------
#' # matrix or data frame of test set cases.
#' # A vector will be interpreted as a row vector for a single case.
#' test <- Test[, -1]
#' fit_FNB <- FuzzyNaiveBayes(
#'   train = Train[, -1],
#'   cl = Train[, 1]
#' )
#'
#' pred_FNB <- predict(fit_FNB, test)
#'
#' head(pred_FNB)
#' head(Test[, 1])
#'
#' @importFrom stats model.extract na.pass sd terms predict
#'
#' @export
FuzzyNaiveBayes <- function(train, cl, fuzzy = T, m = NULL, Pi = NULL) {
  UseMethod("FuzzyNaiveBayes")
}

#' @export
FuzzyNaiveBayes.default <- function(train, cl, fuzzy = T, m = NULL, Pi = NULL) {

  # --------------------------------------------------------
  # Estimating class parameters
  train <- as.data.frame(train)
  cols <- ncol(train) # Number of variables
  if(is.null(cols)){
    cols <- 1
  }
  dados <- train # training data matrix
  M <- c(unlist(cl)) # true classes
  if(!is.factor(M))  M <- factor(M, levels = unique(M))
  # --
  res <- sapply(1:cols, function(i) {is.factor(train[,i])})
  if(sum(res) != cols){ stop("All variables must be categorical (factor).") }
  # --
  N <- nrow(dados)
  # --------------------------------------------------------

  # --------------------------------------------------------
  # Estimating Parameters
  if(is.null(m) & is.null(Pi)){ m <- length(unique(cl))/nrow(dados); Pi <-  1/m}
  # ---
  # Lista: variavel x classes
  parametersC <- lapply(1:length(unique(M)), function(i) {
    lapply(1:cols, function(j) {
      SubSet <- dados[M == unique(M)[i], j]
      #SubSet <- na.omit(SubSet)
      param <- (table(SubSet) + m*pi)/(sum(table(SubSet)) + m)
      return(param)
    })
  })

  model <- e1071::naiveBayes(x = dados, y = cl)
  #parametersC <- model$tables
  # --------------------------------------------------------

  #--------------------------------------------------------
  Pertinencia <- lapply(1:length(unique(M)), function(i) {
    lapply(1:cols, function(j) {
      SubSet <- dados[M == unique(M)[i], j]
      param <- (table(SubSet))/(sum(table(SubSet)))
      return(param)
    })
  })
  #------
  # Probabilidade a priori das classes - consideradas iguais
  pk <- rep(1 / length(unique(M)), length(unique(M)))
  # -------------------------------------------------------


  # -------------------------------------------------------
  structure(list(
    parametersC = parametersC,
    cols = cols,
    M = M,
    Pertinencia = Pertinencia,
    pk = pk,
    fuzzy = fuzzy,
    model = model
  ),
  class = "FuzzyNaiveBayes"
  )
}
# -------------------------


#' @export
print.FuzzyNaiveBayes <- function(x, ...) {
  if (x$fuzzy == T) {
    # -----------------
    cat("\nFuzzy Naive Bayes Classifier for Discrete Predictors\n\n")
    # -----------------
  } else {
    # -----------------
    cat("\nNaive Bayes Classifier for Discrete Predictors\n\n")
    # -----------------
  }
  cat("Class:\n")
  print(levels(x$M))
  # -----------------
}

#' @export
predict.FuzzyNaiveBayes <- function(object,
                                   newdata,
                                   type = "class",
                                   ...) {
  # --------------------------------------------------------
  test <- as.data.frame(newdata)
  # --------------------------------------------------------
  parametersC <- object$parametersC
  cols <- object$cols
  M <- object$M
  Pertinencia <- object$Pertinencia
  pk <- object$pk
  fuzzy <- object$fuzzy
  model = object$model
  # --------------------------------------------------------

  # --------------------------------------------------------
  # Classification
  # --------------
  if ((fuzzy == F) & (type == "class")) {
    class(model) <- "naiveBayes"
    R_M_obs <- predict(model, test)
  } else {
    if ((fuzzy == F)) {
      class(model) <- "naiveBayes"
      R_M_obs <- predict(model, test, type = "raw")
    }
  }


  if (fuzzy == T) {
      N <- nrow(test)
      # --
      P <- lapply(1:length(unique(M)), function(i) {
        densidades <- sapply(1:cols, function(j) {
          # --
          sapply( 1:N, function(v){
            if(is.na(test[v,j])){
              return(1e-5)
            }else{
              pos <- which(names(parametersC[[i]][[j]])==(test[v,j]))
              return(parametersC[[i]][[j]][pos])
            }
          })
          # --
        })
        densidades <- apply(densidades, 1, prod)
        # --
        p <- pk[[i]] * densidades
        # ---
        return(p)
      })
      # --

      # --
      P_fuzzy <- lapply(1:length(unique(M)), function(i) {
        densidades <- sapply(1:cols, function(j) {
          # --
          sapply( 1:N, function(v){
            if(is.na(test[v,j])){
              return(1e-5)
            }else{
              pos <- which(names(Pertinencia[[i]][[j]])==(test[v,j]))
              return(Pertinencia[[i]][[j]][pos])
            }
          })
          # --
        })
        densidades <- apply(densidades, 1, prod)
        # --
        p <- pk[[i]] * densidades
        # ---
        return(p)
      })
      # --

      # --
      R_M_obs <- array(NA,dim = c(length(P_fuzzy[[1]]),length(unique(M))))
      for( i in 1:length(P)){
        R_M_obs[,i] <- P[[i]] * P_fuzzy[[i]]
      }
      # --
  # ---------
  if (type == "class") {
    # -------------------------
    R_M_obs <- sapply(1:nrow(R_M_obs), function(i) which.max(R_M_obs[i, ]))
    resultado <- unique(M)[R_M_obs]
    return(as.factor(c(resultado)))
    # -------------------------
  } else {
    # -------------------------
    Infpos <- which(R_M_obs==Inf)
    R_M_obs[Infpos] <- .Machine$integer.max;
    R_M_obs <- matrix(unlist(R_M_obs),ncol = length(unique(M)))
    R_M_obs <- R_M_obs/rowSums(R_M_obs,na.rm = T)
    # ----------
    colnames(R_M_obs) <- unique(M)
    return(R_M_obs)
    # -------------------------
  }
  }

  return(R_M_obs)

}
