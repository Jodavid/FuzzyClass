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
# Necessary packages
# -------------------
# parallel: to makeCluster function
# doSNOW: to registerDoSnow function
# foreach: to `%dopar%` function
# -------------------

# -----------------------------------------------
#      Fuzzy Naive Bayes Trapeizodal Classifier
# -----------------------------------------------

#' \code{NaiveBayesTrapeizodal} Naive Bayes Trapeizodal Classifier
#'
#'
#' @param train matrix or data frame of training set cases.
#' @param cl factor of true classifications of training set
#' @param cores  how many cores of the computer do you want to use (default = 2)
#' @param fuzzy boolean variable to use the membership function
#'
#' @return A vector of classifications
#'
#' @references
#' \insertRef{moraes2021new}{NaiveBayesClassifiers}
#'
#' @examples
#'
#' set.seed(1) # determining a seed
#' data(iris)
#'
#' # Splitting into Training and Testing
#' split <- caTools::sample.split(t(iris[,1]), SplitRatio = 0.7)
#' Train <- subset(iris, split == "TRUE")
#' Test <- subset(iris, split == "FALSE")
#' # ----------------
#' # matrix or data frame of test set cases.
#' # A vector will be interpreted as a row vector for a single case.
#' test = Test[,-5]
#' fit_NBT <- NaiveBayesTrapeizodal(train =  Train[,-5],
#'                                     cl = Train[,5], cores = 2)
#'
#' pred_NBT <- predict(fit_NBT, test)
#'
#' head(pred_NBT)
#' head(Test[,5])
#'
#'
#' @export
NaiveBayesTrapeizodal <- function( train, cl, cores = 2, fuzzy = T)
  UseMethod("NaiveBayesTrapeizodal")

#' @export
NaiveBayesTrapeizodal.default <- function( train, cl, cores = 2, fuzzy = T){

  # --------------------------------------------------------
  # Estimating class parameters
  cols <- ncol(train) # Number of variables
  dados <- train; # training data matrix
  M <- cl; # true classes
  intervalos = 10 # Division to memberships
  # --------------------------------------------------------
  # --------------------------------------------------------
  # Estimating class memberships
  pertinicesC <- lapply(1:length(unique(M)), function(i){
    lapply(1:cols, function(j){
      SubSet <- dados[M==unique(M)[i],j]
      getMembershipsTrapezoidal(SubSet, intervalos)
    })
  })
  # --------------------------------------------------------

  # --------------------------------------------------------
  # Estimating Trapezoidal Parameters
  parametersC <- lapply(1:length(unique(M)), function(i){
    t(sapply(1:cols, function(j){
      SubSet <- dados[M==unique(M)[i],j]
      getParametersTrapezoidal(SubSet)
    }))
  })
  # --------------------------------------------------------

 # -------------------------------------------------------
  structure(list(pertinicesC = pertinicesC,
                 parametersC = parametersC,
                 cols = cols,
                 M = M,
                 cores = cores,
                 intervalos = intervalos,
                 fuzzy = fuzzy
                 ),
            class = "NaiveBayesTrapeizodal")

}
# -------------------------


#' @export
print.NaiveBayesTrapeizodal <- function(x, ...){

  if(x$fuzzy == T){
  # -----------------
  cat("\nFuzzy Naive Bayes Trapezoidal Classifier for Discrete Predictors\n\n")
  # -----------------
  }else{
    # -----------------
    cat("\nNaive Bayes Trapezoidal Classifier for Discrete Predictors\n\n")
    # -----------------
  }
  cat("Class:\n")
  print(levels(x$M))
  # -----------------
}

#' @export
predict.NaiveBayesTrapeizodal <- function(object,
                                            newdata,
                                          type = "class",
                                            ...){
  # --------------------------------------------------------
  #type <- match.arg("class")
  test <- as.data.frame(newdata)
  # --------------------------------------------------------
  pertinicesC = object$pertinicesC
  parametersC = object$parametersC
  cols = object$cols
  M = object$M
  cores = object$cores
  intervalos = object$intervalos
  fuzzy = object$fuzzy
  # --------------------------------------------------------

  # --------------------------------------------------------
  # Classification
  # --------------
  N_test <- nrow(test)
  # --------------
  # Defining how many CPU cores to use
  #core <- parallel::makeCluster(cores)
  #doSNOW::registerDoSNOW(core)
  core <- parallel::makePSOCKcluster(cores)
  doParallel::registerDoParallel(core)
  # --------------
  # loop start
  R_M_obs <- foreach::foreach(h=1:N_test,.combine = rbind) %dopar% {

    # ------------
    x <- test[h,]
    # ------------
    res <- sapply(1:length(unique(M)), function(i){

        # -------------
        resultadoPerClass <- 1
        # ------------

        sapply(1:cols,function(j){

          # x <= a
          if(x[j] <= parametersC[[i]][j,1]){
            # --------------
            resultadoPerClass = resultadoPerClass * 0
            # --------------
          }
          # --------------
          # a < x < c
          if((x[j] > parametersC[[i]][j,1]) & (x[j] < parametersC[[i]][j,2])){
            # --------------
            resultadoPerClass = resultadoPerClass *
              (((x[j] - parametersC[[i]][j,1])/(parametersC[[i]][j,2] - parametersC[[i]][j,1])) *
                 (2/((parametersC[[i]][j,4]-parametersC[[i]][j,1]) + (parametersC[[i]][j,3] - parametersC[[i]][j,2]))))
            resultadoPerClass <- unlist(resultadoPerClass)
            # --------------
          }
          # --------------
          # c <= x <= d
          if((x[j] >= parametersC[[i]][j,2]) & (x[j] >= parametersC[[i]][j,3]) ){
            # --------------
            resultadoPerClass = resultadoPerClass *
              (2/((parametersC[[i]][j,4]- parametersC[[i]][j,1]) +
                    (parametersC[[i]][j,3] - parametersC[[i]][j,2])))
            # --------------
          }
          # --------------
          # d< x < b
          if((x[j] > parametersC[[i]][j,3]) & (x[j] < parametersC[[i]][j,4]) ){
            # --------------
            resultadoPerClass = resultadoPerClass *
              (((parametersC[[i]][j,4] - x[j])/(parametersC[[i]][j,4] - parametersC[[i]][j,3])) * (2/((parametersC[[i]][j,4] - parametersC[[i]][j,1]) + (parametersC[[i]][j,3] - parametersC[[i]][j,2]))))
            # --------------
          }
          # --------------
          #b <= x
          if(parametersC[[i]][j,4] <= x[j]  ){
            # --------------
            resultadoPerClass = resultadoPerClass * 0
            # --------------
          }

      # -----------------------------------------------------------------------
      # -----------------------------------------------------------------------
          if(fuzzy == T){
            # --------------
            # Mcl(Xi)
            for (st in 1:intervalos) {
              if(st == intervalos){
                if((x[j] >= pertinicesC[[i]][[j]][st,1])& (x[j] <= pertinicesC[[i]][[j]][st,2])){
                  resultadoPerClass = resultadoPerClass * pertinicesC[[i]][[j]][st,3]
                }
              }else{
                if((x[j] > pertinicesC[[i]][[j]][st,1]) & (x[j] < pertinicesC[[i]][[j]][st,2])){
                  resultadoPerClass = resultadoPerClass * pertinicesC[[i]][[j]][st,3]
                }
              }
            }
          }
    # -----------------------------------------------------------------------
    # -----------------------------------------------------------------------

          # --------------
          # P(Wcl)
          resultadoPerClass = resultadoPerClass * 1/length(unique(M))
          # --------------
          return(resultadoPerClass)
        })
        # --------------------------------------------------------
      })
      # --------------------------------------------------------
      produto <- matrix(as.numeric(res), ncol = length(unique(M)))
      produto <- apply(produto, 2, prod)
      # --------------------------------------------------------
      #R_M_class <- which.max(produto)
      R_M_class <- produto
      # --------------------------------------------------------
      return(R_M_class)
  }
    # ------------
  # -------------------------
  parallel::stopCluster(core)
  # ---------
  if(type == "class"){
    # -------------------------
    R_M_obs <- sapply(1:nrow(R_M_obs), function(i) which.max(R_M_obs[i,]) )
    resultado <- unique(M)[R_M_obs]
    return(as.factor(c(resultado)))
    # -------------------------
  }else{
    # -------------------------
    colnames(R_M_obs) <- unique(M)
    return(R_M_obs)
    # -------------------------
    }


}
