# # # Definition of the Ckrige-methods
# # # Christoph Hofer, 30-03-2010
# if (!isGeneric("CKrige"))
# setGeneric( name = "CKrige", function(formula, data, locations, object, ...)
#   standardGeneric("CKrige")
# )
# 
# "CKrige.polygons" <- function(formula, data, locations, object,  method = 2, ex.out = FALSE)
# {
#   f.polygons.CKrige(formula = formula, data = data, locations = locations,
#     object = object, method = method, ex.out = ex.out)
# }
# #
# setMethod("CKrige", c(	"formula", "data.frame", "formula", "preCKrigePolygons"),
#   CKrige.polygons
# )
# #
# "CKrige.points" <- function(formula, data, locations, object, method = 2, ex.out = FALSE)
# {
#   f.points.CKrige(formula = formula, data = data, locations = locations, 
#     object = object, method = method, ex.out = ex.out)
# }
# #
# setMethod("CKrige", c(	"formula", "data.frame", "formula", "preCKrigePoints"),
#   CKrige.points
# )
# #

################################################
## 2023-01-25 A. Papritz revised method definition

## definition of the generic function
if (!isGeneric("CKrige")){
  setGeneric( 
    name = "CKrige", 
    function(formula, data, locations, object, ...){
      standardGeneric("CKrige")
    }
  )
}

## definition of CKrige method for signature 
## "formula", "data.frame", "formula", "preCKrigePolygons"

## definition of wrapper function
CKrige.polygons <- function(
  formula, data, locations, object,  method = 2, ex.out = FALSE
){
  f.polygons.CKrige(
    formula = formula, data = data, locations = locations,
    object = object, method = method, ex.out = ex.out
  )
}
## method definition
setMethod(
  "CKrige", 
  signature = c( "formula", "data.frame", "formula", "preCKrigePolygons" ),
  definition = CKrige.polygons
)


## definition of CKrige method for signature "formula", "data.frame",
## "formula", "preCKrigePoints"

## definition of wrapper function
CKrige.points <- function(
  formula, data, locations, object, method = 2, ex.out = FALSE
){
  f.points.CKrige(
    formula = formula, data = data, locations = locations, 
    object = object, method = method, ex.out = ex.out
  )
}
## method definition
setMethod("CKrige", c(	"formula", "data.frame", "formula", "preCKrigePoints"),
  CKrige.points
)
