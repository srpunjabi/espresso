# Espresso
An iOS app that shows coffee shops near you in playful a way.

### Screenshots:
<img src="Screenshots/Home.png?" alt="alt text" width="250" height="444.66">
<img src="Screenshots/Details.png?" alt="alt text" width="250" height="444.66">
<img src="Screenshots/ChooseNavatar.png?" alt="alt text" width="250" height="444.66">



### Works On:
iOS 8 and later

### Usage:
1. Open the app once installed
2. Look for an avatar at the center of the screen thats your location
3. Move around the map or pinch out to see CoffeeMug pins around you these are coffee shop near you.
4. Tap on the CoffeeMug pin to reveal more details.
5. On the details page you will see more info about the coffee shop.



### Build Instructions:
1.  This app was written with Swift 2.2 so it will require Xcode 7.3 or higher
2.  Clone the repo or download the zip file
3.  Open Espresso.xcworkspace since the app uses Cocoapods
4.  Build and run

### Details:
This app follows MVVM to a certain extend along with Functional Reactive Programming via RxSwift

##### ViewControllers:
1. **MapViewController:**  Observers NearbyViewModel to get nearby coffe shops and displays them on mapView with pins.
2. **ShopDetailsController:**  A static TableViewController that displays additional info about the CoffeeShop.
3. **NavatarTableViewController:**  Instead of showing a boring dot for user's location it allows user to pick from different characters.

##### ViewModels:
1. **NearbyViewModel:**  Handles data and initiating network request whenever a new location is available.

##### Models:
1. **CoffeeShop:**  Coffee shop model that directly maps json to various properties using ObjectMapper.
2. **CoffeeShopAnnotation:**  Custom MKAnnotation used to display coffeeShops and user's location.

##### Network:
1. **FoursquareEndpoint:**  Network layer that makes network request to Foursquare's search API using Alamofire.

### Features:
1. **Custom Pins:** Shows nearby coffeShops with custom CoffeeCup pins 
2. **Navatars:** Replaces the boring dot symbol for user's location with avatars like Darth Vader, Batman, Hipster, etc
3. **My Location:** Centers the map around the user whenever pressed 
4. **Phone URL:**  Lets the user directly call the coffee shop
5. **Directions:**  Directly opens the maps app and shows directions to the coffeeshop
6. **Web URL:**  Opens the website for Coffee Shop in Safari

# Contributors:

### Artwork:

### ThirdParty Libraries:
