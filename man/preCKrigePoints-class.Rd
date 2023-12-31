% 2023-12-12 A. Papritz correction of spelling errors and minor revision of
% text
% cd R.user.home/constrainedKriging/constrainedKriging_02-7/pkg/man/
% R CMD Rdconv -t html -o bla.html preCKrigePoints-class.Rd ; open bla.html;
% R CMD Rd2pdf --force preCKrigePoints-class.Rd;
% hunspell -d en_GB-ise,en_GB-ize,en_GB-large -t -i mac  preCKrigePoints-class.Rd
\name{preCKrigePoints-class}
\Rdversion{1.1}
\docType{class}
\alias{preCKrigePoints}
\alias{preCKrigePoints-class}
\alias{print.preCKrigePoints}
\alias{summary.preCKrigePoints}
\alias{show,preCKrigePoints-method}


\title{Class "preCKrigePoints"}

\description{Class of objects that are generated by \code{\link{preCKrige}}
if the attribute \code{newdata} is of class \cr
\dQuote{\code{SpatialPoints}} or \dQuote{\code{SpatialPointsDataFrame}}.
This class has a \code{show}, \code{summary} and a \code{\link{CKrige}} method.}

\section{Objects from the Class}{
Objects can be created by calls of the generic function
\code{\link{preCKrige}}.  }

\section{Slots}{
  \describe{
    \item{\code{covmat}:}{Object of class \code{"list"},
    see \code{\link{preCKrige}}, section \emph{Value}. }
    \item{\code{posindex}:}{Object of class \code{"list"},
    see \code{\link{preCKrige}}, section \emph{Value}. }
    \item{\code{model}:}{Object of class \code{"list"},
    see \code{\link{preCKrige}}, section \emph{Value}.  }
    \item{\code{data}:}{Object of class \code{"data.frame"},
    see \code{\link{preCKrige}}, section \emph{Value}.  }
    \item{\code{coords}:}{Object of class \code{"matrix"},
    see \code{\link{preCKrige}}, section \emph{Value}.  }
  }
}
\section{Methods}{
  \describe{
    \item{CKrige}{\code{signature(formula = "formula", data = "data.frame", locations = "formula",
    object = "preCKrigePoints", method = "numeric", ex.out = "logical")} }
	 }
}
\author{Christoph Hofer, \email{christoph.hofer@alumni.ethz.ch}}

\seealso{\code{\link{preCKrige}}, \code{\linkS4class{preCKrigePolygons}}  }

\examples{
showClass("preCKrigePoints")
}

\keyword{classes}
