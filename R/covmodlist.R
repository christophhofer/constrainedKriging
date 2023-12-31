# Christoph Hofer 5-4-2010
#
# 2023-11-17 A. Papritz
# changes in function covmodellist:
#   - elimination of duplicated entry for gencauchy
#   - correction of number of parameters and bounds for circular
#   - formatting of code
#   - change of order of models
#
covmodellist <- function(p)
{
  if( missing(p) ){ p <- TRUE }
  if(identical( p, TRUE ) ){
    cat("                                            \n")
    cat("                                            \n")
    cat("                                            \n")
    cat("   implemented covariance functions inside constrainedKriging \n")
    cat("   -------------------------------------------------------\n")
    cat("   covariance model   |", "parameter for 2D", "\n")
    cat("   -------------------------------------------------------\n")
    cat("   *   bessel         |", "a > 0", "\n")
    cat("   *   cauchy         |", "a > 0", "\n")
    cat("   *   cauchytbm      |", "a = (0,2], b > 0", "\n")
    cat("   *   circular       |", "NULL", "\n")
    cat("   *   constant       |", "NULL", "\n")
    cat("   *   cubic          |", "NULL", "\n")
    cat("   *   dampedcosine   |", "a > 1" ,"\n")
    cat("   *   exponential    |", "NULL", "\n")
    cat("   *   gauss          |", "NULL", "\n")
    cat("   *   gencauchy      |", "a = (0,2], b > 0", "\n")
    cat("   *   gengneiting    |", "a = 1, b >= 2.5 , a = 2, b >= 3.5, a = 3, b >= 4.5", "\n")
    cat("   *   gneiting       |", "NULL", "\n")
    cat("   *   hyperbolic     |", "a,b,c > 0 | a,c,> 0, b = 0 | a >= 0, c > 0, b < 0", "\n")
    cat("   *   lgd1           |", "a in (0,0.5], b > 0", "\n")
    cat("   *   matern         |", "a > 0", "\n")
    cat("   *   nugget         |", "NULL", "\n")
    cat("   *   penta          |", "NULL", "\n")
    cat("   *   power          |", "a > 1.5", "\n")
    cat("   *   qexponential   |", "a in [0,1]", "\n")
    cat("   *   spherical      |", "NULL", "\n")
    cat("   *   stable         |", "a in (0,2]", "\n")
    cat("   *   wave           |", "NULL", "\n")
    cat("   *   whittle        |", "a > 0", "\n")
    cat("   -------------------------------------------------------\n")
    cat("                                            \n")
    cat("                                            \n")
    cat("                                            \n")
  }
  #n.paramter = number of parameter
  #
  return(
    invisible(
      list(
        model = c(
          "bessel", "cauchy", "cauchytbm", "circular", "constant",
          "cubic", "dampedcosine", "exponential", "gauss",
          "gencauchy", "gengneiting", "gneiting", "hyperbolic", "lgd1",
          "matern", "nugget", "penta", "power", "qexponential",
          "spherical", "stable", "wave", "whittle"
        ),
        n.parameter = c(
          1, 1, 2, 0, 0,
          0, 1, 0, 0,
          2, 2, 0, 3, 2,
          1, 0, 0, 1, 1,
          0, 1, 0, 1
        ),
        parameter.interval = list(
          list(0), list(0), list(c(0,2), c(0)), list(NULL), list(NULL),
          list(NULL), list(c(1)), list(NULL), list(NULL),
          list(c(0,2), c(0)), list(c(1, 2.5), c(2, 3.5), c(3, 4.5)), list(NULL), list(c(0), c(0), c(0)), list(c(0, 0.5), c(0)),
          list(c(0)), list(NULL), list(NULL), list(c(1.5)), list(c(0,1)),
          list(NULL), list(c(0,2)), list(NULL), list(c(0))
        )
      )
    )
  )

}# end of function covmodellist

covmodel <- function(modelname, mev, nugget, variance, scale, parameter = NULL, add.covmodel)
# # #
# # #  Function generates a variogramm model
# # # Christoph Hofer , 12-04-2010

# 2023-11-17 A. Papritz correction of allowed bound for third parameter in
#                       third condition for hyperpolic model
{
  m <- covmodellist(FALSE);
  # check modelname
  if( missing( modelname ) ){
    covmodellist(); return(invisible())}

  if( sum( modelname == m$model ) == 0 ){
    covmodellist(); stop(
      paste( modelname,
        " is not a proper covariance model \n", "use one of the listed above \n", sep =""))
  }

  if( missing( mev ) ){ mev <- 0 }
  if( missing( nugget ) ){ nugget <- 0 }
  if( missing( variance ) ){ variance <- 0 }
  if( missing( scale ) ){ scale  <- 0 }


  # check whether the user entered the right numbers of parmeters
  if( length( parameter) != m$n.parameter[ modelname == m$model ] )
  {
    covmodellist();

    stop( paste( "wrong parametrisation \n", modelname," has ", m$n.parameter[ which( modelname ==
          m$model ) ], " parameter \n", sep = "" ) )
  }

  # check parameter values
  # one paramter


  if( length( parameter) == 1 )
  {
    a <- m$parameter.interval[ modelname == m$model ][[ 1 ]][[ 1 ]]
    if( modelname == "qexponential" && parameter < a[1] || modelname == "qexponential" && parameter > a[2] )
    {
      stop("parameter a  has  to be in [0,1]")
    }
    a <- m$parameter.interval[ modelname == m$model ][[ 1 ]][[ 1 ]]
    if( modelname == "stable" && parameter < a[1] || modelname == "stable" && parameter > a[2] )
    {
      stop("parameter a  has  to be in (0,2]")
    }

    if( modelname == "exponential" && parameter < a[1] || modelname == "exponential" && parameter > a[2] )
    {
      stop("parameter a has to be in (0,2]")
    }
    if( parameter <= m$parameter.interval[ modelname == m$model ][[ 1 ]][[ 1 ]][ 1 ]  )
    {
      stop(paste( "parameter a has to be > ",
          m$parameter.interval[ modelname == m$model ][[ 1 ]][ 1 ], sep ="") )
    }
  }

  # check parameter values
  # two parameters
  # a = (0,2], b > 0

  if(length( parameter) == 2 )
  {
    p.check = FALSE

    if( modelname == "gengneiting")
    {
      a1 <- m$parameter.interval[ modelname == m$model ][[1]][[1]][1]
      a2 <- m$parameter.interval[ modelname == m$model ][[1]][[2]][1]
      a3 <- m$parameter.interval[ modelname == m$model ][[1]][[3]][1]
      #
      b1 <- m$parameter.interval[ modelname == m$model ][[1]][[1]][2]
      b2 <- m$parameter.interval[ modelname == m$model ][[1]][[2]][2]
      b3 <- m$parameter.interval[ modelname == m$model ][[1]][[3]][2]
      #
      if( sum( parameter[1] == c(a1,a2,a3) ) != 1 ){ stop("parameter a must be either 1, 2 or 3") }
      if( parameter[1] == a1 && parameter[2] <= b1 ){ stop("if parameter a = 1, b has to be >2.5") }
      if( parameter[1] == a2 && parameter[2] <= b2 ){ stop("if parameter a = 2, b has to be > 3.5") }
      if( parameter[1] == a3 && parameter[2] <= b3 ){ stop("if parameter a = 3, b has to be > 4.5") }
      #
      p.check = TRUE
    }
    #
    a <- m$parameter.interval[ modelname == m$model ][[1]][[1]]
    b <- m$parameter.interval[ modelname == m$model ][[1]][[2]]
    #
    if( modelname == "lgd1")
    {
      p.check =FALSE
      if(parameter[1] <= a[1] || parameter[1] > a[2] )
      {
        stop("parameter a has to be in (0, 0.5]" )
      }
      p.check =TRUE
    }
    #
    if(p.check == FALSE && parameter[1] <= a[1] && parameter[2] > a[2]){ stop("parameter a has to be in (0,2]" ) }
    if(p.check == FALSE && parameter[2] <= b[1]){ stop("parameter b has to be > 0") }
  }
  #
  if(length( parameter) == 3 )
  {
    if(modelname == "hyperbolic")
    {
      a <- m$parameter.interval[ modelname == m$model ][[1]][[1]][1]
      b <- m$parameter.interval[ modelname == m$model ][[1]][[2]][1]
      c <- m$parameter.interval[ modelname == m$model ][[1]][[3]][1]
      if( parameter[2] < b )
      {
        if( parameter[1] < a || parameter[3] <= c){stop("parameter a has to be >= 0 and c > 0 if b < 0 ") }
      }
      if( parameter[2] == b)
      {
        if( parameter[1] <= a || parameter[3] <= c){stop("parameter a has to be > 0 and c > 0 if b = 0 ") }
      }
      if( parameter[2] > b)
      {
        if( parameter[1] <= a || parameter[3] < c){stop("parameter a has to be > 0 and c >= 0 if b > 0 ") }
      }
    }
  }

  ### create covmodel
  covmodel <- list( list( model = modelname, variance = variance,
      scale = scale, parameter = parameter ) )

  ### create covmodel with nugget (variance of a microscale white noise spatail process
  if( nugget != 0)
  {
    covmodel.nugget <- list( list( model = "nugget", variance = nugget,
        scale = 0, parameter = NULL ) )
    class(covmodel.nugget) <- "list"
    covmodel <- c(covmodel.nugget,  covmodel  )
  }
  ### create  list component with the measurement error variance
  covmodel.mev <- list( list( model = "mev", variance = mev,
      scale = 0, parameter = NULL ) )
  class(covmodel.mev) <- "list"
  covmodel <- c(covmodel.mev,  covmodel  )

  ### add an existing covmodel to the generated one
  if( !missing( add.covmodel ) )
  {
    if( is(add.covmodel)[1] == "covmodel" )
    {
      class(add.covmodel) <- "list"
      covmodel <- c(add.covmodel, covmodel)
    }
    else
    {
      stop("add.covmodel is not a covmodel object")
    }

  }

  class( covmodel ) <- "covmodel"
  return(  covmodel )

}


# method to display covmodel object in a readable way

print.covmodel<- function(x,...)
{
  if (!inherits(x, "covmodel"))
  stop("Not a covmodel list")
  t.m.n <- length(x)

  t.m <- unlist( lapply(x, function(x){return( x$model ) } ) )
  t.psill <- unlist( lapply(x, function(x){return(x$variance)}) )
  t.scale <- unlist( lapply(x, function(x){ return( x$scale ) } ) )
  t.p <- lapply(x, function(x){return(x$parameter)})
  t.p.n <-  unlist( lapply(x, function(x){ return( length( x$parameter ) ) } ) )
  t.p.max <- max( unlist( lapply(x, function(x){ return( length( x$parameter ) ) } ) ) )
  if(t.p.max != 0)
  {
    t.p.mat <- data.frame( matrix( rep(0, t.m.n * t.p.max), ncol = t.p.max, nrow = t.m.n ) )
    for(i in 1:t.m.n)
    {
      if(is.null(t.p[[ i ]])){t.p[[ i ]] <- NA}
      t.p.mat[i,] <- t.p[[ i ]]
    }

    colnames(t.p.mat) <- letters[1:t.p.max]
    t.d <- data.frame( matrix(ncol = 3 + t.p.max, nrow = t.m.n) )
    t.d <- cbind(t.m, t.psill, t.scale, t.p.mat)
    colnames(t.d) = c("model name   ", "psill", "scale", colnames(t.p.mat))
    t.d <- as.data.frame(t.d, optional = FALSE)
  }
  else
  {
    t.d <- as.data.frame( matrix(ncol = 3, nrow = t.m.n) , stringsAsFactors= TRUE, optional = FALSE)
    t.d <- cbind( t.m, as.numeric(t.psill), as.numeric( t.scale) )
    colnames(t.d) = c("model name   ", "psill", "scale")
    t.d <- as.data.frame(t.d, optional = FALSE)
  }
  print(t.d, right =FALSE)
}
