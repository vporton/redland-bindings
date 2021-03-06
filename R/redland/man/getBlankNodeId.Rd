% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Node.R
\docType{methods}
\name{getBlankNodeId}
\alias{getBlankNodeId}
\alias{getBlankNodeId,Node-method}
\title{Get the blank identifier that has been assigned for a specified Node object}
\usage{
getBlankNodeId(.Object)

\S4method{getBlankNodeId}{Node}(.Object)
}
\arguments{
\item{.Object}{a Node object}
}
\value{
a blank node identifier
}
\description{
Get the blank identifier that has been assigned for a specified Node object
}
\details{
When a Node object is initialized with no value specified, i.e. node <- Node(""),
a blank node is created and a locally unique identifier is generated by librdf. This method
retrieves this identifier and returns in to the caller.
}
\examples{
world <- new("World")
# a blank node is created with a unique identifier generated by librdf
node <- new("Node", world, blank=NULL)
nodeId <- getBlankNodeId(node)
}
