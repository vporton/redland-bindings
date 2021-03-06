% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Parser.R
\docType{methods}
\name{parseFileIntoModel}
\alias{parseFileIntoModel}
\alias{parseFileIntoModel,Parser,World,character,Model-method}
\title{Parse the contents of a file into a model}
\usage{
parseFileIntoModel(.Object, world, filePath, model, ...)

\S4method{parseFileIntoModel}{Parser,World,character,Model}(.Object, world,
  filePath, model, baseUri = as.character(NA))
}
\arguments{
\item{.Object}{a Parser object}

\item{world}{a World object}

\item{filePath}{a file that contains the RDF content}

\item{model}{a Model object to parse the RDF content into}

\item{...}{(Additional parameters)}

\item{baseUri}{a base URI (i.e. XML base) to apply to the model}
}
\description{
The contents of a the specified file are read and parsed into the initialized
Parser object
}
\details{
The parser factory name specified during initialization determines how the content is
parsed, for example, if 'rdfxml' was specified during parser initialization, then the parser
expects RDF/XML content as specified in the W3C recommendation (http://www.we3.org/TR/REC-rdf-syntax)
}
\examples{
world <- new("World")
storage <- new("Storage", world, "hashes", name="", options="hash-type='memory'")
model <- new("Model", world, storage, options="")
# Create the default "rdfxml" parser
parser <- new("Parser", world)
filePath <- system.file("extdata/example.rdf", package="redland")
parseFileIntoModel(parser, world, filePath, model)
}
