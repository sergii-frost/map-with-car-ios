# map-with-car-ios
This is an investigation of how to build moving/rotating car (similar to Uber app)

## Tasks solved

* show annotation with custom icon (Car in our case)
* calculate direction (aka bearing) between 2 points on map (based on [Haversine formla](https://en.wikipedia.org/wiki/Haversine_formula))
* rotate car icon correspondingly 
* zoom map to always show both user and car
* "random" locations generator logic was added in order to test "moving car" (new location is generated from the previous one with distance between 0..100m and bearing betweeen 0..360 degrees)

## Project structure

* `ViewController` is responsible for showing map, being MapDelegate and handling IBActions
* `CarLocationService` is responsible for generating, providing and storing car locations
* `MapDrawUtil` is responsible for drawing objects on the map (e.g. car, car route)
* `MyLocationManager` is responsible for handling location permissions and location updates
* Different extensions are used as utils for random data generation, custom calculations

## Pitfalls

* Car icon rotation is a bit tricky. Direction/Bearing is based on compass and North is 0°, while rotation goes clockwise (e.g. East is 90°, South is 180°, West is 270°). While image rotation happens counter-clockwise with 0° equal to original image rotation. To apply rotation for the car image the angle should be "inverted" like `360 - direction`.

* Image rotation is not trivial either, separate extension was created in order to do that. Image quality can be impacted by rotation algoritm. 

* zooming map to contain all the coordinates (e.g. user and car) is a bit tricky as well.
