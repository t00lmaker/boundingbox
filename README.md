# Boundingbox


Boundingbox is a command-line application that creates a set of Boundingboxes  based on peers created from a csv file. Two operations can be performed on this set of boundingboxes:

* Given a list of coordinates, associate each cordenada with the Boundingbox to which it belongs.

* Given a coordinate of origin and destination, returns the respectives boundingboxes.

## Installation
 
First you need to compile the application, which can be done by running the command in the application directory:

``````
$ mix escript.build
```````

Then run the application:

```````
$ ./boundingbox
````````

The command above, executes the default options of the application, equivalent to:

```````````
$ ./boundingbox --op=check-point --in=pairs.1.csv --params=coordinates.1.csv --out=result.1.csv
````````````

* _op_ operation performed is specified by the 'op' option;

* _in_ specifies the file with the coordinate list for pairing for the creation of boundingboxes,

* _params_ the input file for the operation;

* _out_ the file where the result of the operation will be placed.

The option op, can receive the values ​​"check-point", which is equivalent to the first detailed 
operation above, and "origin-dest" that equates the second operation. The other parameters can 
be any file that is within the directory souces of the application and that obey the data 
structures described below.

## Data Structures

The input and output files that can be found in the source directory of the application:

* **pairs.csv** contains the pairs that will serve to create the boundingboxes.
* **coordinates.csv and origin_dest.csv** are parameters for the operations mentioned above, the first for operation one and the second for operation two.
* **result.csv**  file where the application will flush the result of the processing.

All input files receive the same pattern, each line is a coordinate with longitude and latitude.

In the case of *pairs.csv* the ones that will be used to create the boundingboxes, they will be read with the following structure: 
```````````
[{lon1, lat1}, {lon2, lat2}], [{lon2, lat2}, {lon3, lat3}], lon3, lat3}, {lon4, lat4}], ....]
```````````

For *origin_dest.csv* the pairs that will form origin and destination will be created by dividing the file into pairs, following the following pattern:

````````````
pair 1 (line 1 = origin, line 2 destination), pair 2 (line 3 = origin, line 4 = destination), pair 3 (line 5 = origin, line 6 = destination)
````````````

In the case of *result.csv*, the structure depends on the executed operation, if the first operation the structure should be similar to this:

```````````
{{x, y}, [[{P1x, P1y}, {P2x, P2y}, {P3x, P3y}, {P4x, P4y}], ...}
````````````

Where {x, y} represents the point consulted, and a list of boundingboxes, where one face of it is represented by a list of points, fromado pos coordinates. The list specifies which boundingboxes the point is part of.

For the second operation the structure should be similar to this:

``````````````
[[P1x, P1y}, {P2x, P2y}, {P3x, P3y}, {P4x, P4y}], [{P1x, P1y}, {P2x, P2y}, {P3x, P3y} }]]
``````````````

A list with two boundingboxes, the first one related to origin and the second related to the destination. If the origin and destination are in the same boundingboxes, the list will have an element. If source and destination are not found in boundingboxes, the list returns empty.

### Run tests

For the tests execute run the command below in the application directory:

```````````
$ mix test
```````````

### TODO 

* Error Handler
* Improve Data struture
* Feedback operations to user  