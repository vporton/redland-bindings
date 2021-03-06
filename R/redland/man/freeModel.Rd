% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Model.R
\docType{methods}
\name{freeModel}
\alias{freeModel}
\alias{freeModel,Model-method}
\title{Free memory used by a librdf model.}
\usage{
freeModel(.Object)

\S4method{freeModel}{Model}(.Object)
}
\arguments{
\item{.Object}{a Model object}
}
\description{
Free memory used by a librdf model.
}
\details{
After this method is called, the Model object is no longer usable and should
be deleted \code{"rm(model)"} and a new object created.
}
\examples{
world <- new("World")
storage <- new("Storage", world, "hashes", name="", options="hash-type='memory'")
model <- new("Model", world, storage, options="")
# At this point, some operations would be performed with the model.
# See '?redland' for a complete example.
# When the Model object is no longer needed, the resources it has allocated can be freed.
freeModel(model)
rm(model)
}
