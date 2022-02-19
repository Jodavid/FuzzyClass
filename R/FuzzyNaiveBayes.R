#' Fuzzy Naive Bayes
#'
#' \code{FuzzyNaiveBayes} Fuzzy Naive Bayes
#'
#'
#' @param train matrix or data frame of training set cases.
#' @param cl factor of true classifications of training set
#' @param cores  how many cores of the computer do you want to use (default = 2)
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
#' data(iris)
#'
#' # Splitting into Training and Testing
#' split <- caTools::sample.split(t(iris[, 1]), SplitRatio = 0.7)
#' Train <- subset(iris, split == "TRUE")
#' Test <- subset(iris, split == "FALSE")
#' # ----------------
#' # matrix or data frame of test set cases.
#' # A vector will be interpreted as a row vector for a single case.
#' test <- Test[, -5]
#' fit_FNB <- FuzzyNaiveBayes(
#'   train = Train[, -5],
#'   cl = Train[, 5], cores = 2
#' )
#'
#' pred_FNB <- predict(fit_FNB, test)
#'
#' head(pred_FNB)
#' head(Test[, 5])
#'
#' @importFrom stats model.extract na.pass sd terms predict
#'
#' @export
FuzzyNaiveBayes <- function(train, cl, cores = 2, fuzzy = T, m = NULL, Pi = NULL) {
  UseMethod("FuzzyNaiveBayes")
}

#' @export
FuzzyNaiveBayes.default <- function(train, cl, cores = 2, fuzzy = T, m = NULL, Pi = NULL) {

  # --------------------------------------------------------
  # Estimating class parameters
  train <- as.data.frame(train)
  cols <- ncol(train) # Number of variables
  if(is.null(cols)){
    cols <- 1
  }
  dados <- train # training data matrix
  M <- c(unlist(cl)) # true classes
  M <- factor(M, labels = unique(M))

  N <- nrow(dados)
  # --------------------------------------------------------

  # --------------------------------------------------------
  # Estimating Gamma Parameters
  if(is.null(m) & is.null(Pi)){ m <- length(unique(cl))/nrow(dados); Pi <-  1/m}
  # ---
  # Lista: variavel x classes
  model <- e1071::naiveBayes(x = dados, y = cl)
  parametersC <- model$tables
  # --------------------------------------------------------

  #--------------------------------------------------------
  Sturges <- Sturges(dados, M);
  Comprim_Intervalo <- Comprim_Intervalo(dados, M, Sturges);
  minimos <- minimos(dados, M, cols);
  Freq <- Freq(dados, M, Comprim_Intervalo, Sturges, minimos, cols);
  Pertinencia <- Pertinencia(Freq, dados, M);
  #------
  # --------------------------------------------------------
  # Cria a funcao de pertinencia para cada classe, a partir das frequencias relativas
  Pertinencia <- lapply(1:length(unique(M)), function(i) {
    Freq[[i]] / nrow(dados[M == unique(M)[i], ])
  })
  # ------
  # Probabilidade a priori das classes - consideradas iguais
  pk <- rep(1 / length(unique(M)), length(unique(M)))
  # -------------------------------------------------------


  # -------------------------------------------------------
  structure(list(
    parametersC = parametersC,
    minimos = minimos,
    cols = cols,
    M = M,
    cores = cores,
    Comprim_Intervalo = Comprim_Intervalo,
    Pertinencia = Pertinencia,
    Sturges = Sturges,
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
  minimos <- object$minimos
  cols <- object$cols
  M <- object$M
  cores <- object$cores
  Comprim_Intervalo <- object$Comprim_Intervalo
  Pertinencia <- object$Pertinencia
  Sturges <- object$Sturges
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
  P <- lapply(1:length(unique(M)), function(i) {
        densidades <- sapply(1:cols, function(j) {
          parametersC[[j]][i,2]*test[,j]
        })
        densidades <- apply(densidades, 1, prod)
        p <- pk[[i]] * densidades

        # ---
        return(p)
      })

  N_test <- nrow(test)
  # --------------
  # Defining how many CPU cores to use
  core <- parallel::makePSOCKcluster(cores)
  doParallel::registerDoParallel(core)
  # --------------
  # loop start
  R_M_obs <- foreach::foreach(h = 1:N_test, .combine = rbind) %dopar% {

    # ------------
    x <- test[h, ]
    # ------------
    ACHOU_t <- c()
    ACHOU <- 0

    # ---------------
    for (classe in 1:length(unique(M))) {
      # --
      # --
      for (coluna in 1:cols) { # coluna da classe
        for (linhaF in 1:Sturges[[classe]]) { # linha da classe
          faixa <- minimos[[classe]][coluna] + Comprim_Intervalo[[classe]][coluna] # faixa de frequencia inicial
          if (x[coluna] < faixa) { # ve se valor da classe pertence aaquela faixa
            ACHOU[coluna] <- Pertinencia[[classe]][linhaF, coluna] # acumula valor na faixa de frequencia e interrompe este ultimo for
            break
          }
          if (linhaF == Sturges[[classe]]) {
            ACHOU[coluna] <- Pertinencia[[classe]][linhaF, coluna]
            break
          }
          faixa <- faixa + Comprim_Intervalo[[classe]][coluna] # troca de faixa -> proxima
        }
      }
      # ---
      ACHOU_t <- rbind(ACHOU_t, ACHOU) # Classes são as linhas
      # ---
    }
    # -----
    row.names(ACHOU_t) <- unique(M)
    # --------------------------------------------------------
    ACHOU_t <- apply(ACHOU_t, 1, prod)

    f <- sapply(1:length(unique(M)), function(i) {
      P[[i]][h] * ACHOU_t[i]
    })
  # -------------------------------------------------------

    return(f)
  }
  # ------------
  # -------------------------
  parallel::stopCluster(core)
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
    R_M_obs <- matrix(unlist(R_M_obs),ncol = cols)
    R_M_obs <- R_M_obs/rowSums(R_M_obs,na.rm = T)
    # ----------
    colnames(R_M_obs) <- unique(M)
    return(R_M_obs)
    # -------------------------
  }
  }

  return(R_M_obs)


}
