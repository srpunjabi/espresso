# Espresso
An iOS app that uses the FourSquare API to show coffee shops near you in a playful way.  The app uses Functional Reactive Programming via RxSwift along with MVVM pattern.

### Screenshots:
<img src="Screenshots/Home.png?" alt="alt text" width="187.5" height="333.5">
<img src="Screenshots/Pin.png?" alt="alt text" width="187.5" height="333.5">
<img src="Screenshots/Details.png?" alt="alt text" width="187.5" height="333.5">
<img src="Screenshots/ChooseNavatar.png?" alt="alt text" width="187.5" height="333.5">




### Works On:
iOS 8 and later

### Usage:
1. Open the app once installed
2. Look for an avatar at the center of the screen thats your current location
3. Move around the map or pinch out to see CoffeeCup pins around you these are coffee shops near you.
4. Tap on the CoffeeCup pin to reveal more details.
5. On the details page you will see more info about the coffee shop.



### Build Instructions:
1.  This app was written with Swift 2.2 so it will require Xcode 7.3 or higher
2.  Clone the repo or download the zip file
3.  Open Espresso.xcworkspace since the app uses Cocoapods
4.  Build and run

### Details:
This app follows MVVM to a certain extend along with Functional Reactive Programming via RxSwift

##### ViewControllers:
1. **MapViewController:**  Observers NearbyViewModel to get nearby coffe shops and displays them on a mapView with pins.
2. **ShopDetailsController:**  A static UITableViewController that displays additional info about the CoffeeShop.
3. **NavatarTableViewController:**  A static UITableViewController that lets the user pick from from different Navatars (current location avatar).

##### ViewModels:
1. **NearbyViewModel:**  Handles data and initiating network request whenever a new location is available.

##### Models:
1. **CoffeeShop:**  Coffee shop model that directly maps json to various properties using ObjectMapper.
2. **CoffeeShopAnnotation:**  MKAnnotation subclass used to display coffeeShops and user's current location using custom pins.

##### Network:
1. **FoursquareEndpoint:**  Network layer that makes network request to Foursquare's search API using Alamofire.

### Features:
1. **Custom Pins:** Shows nearby coffeShops with custom CoffeeCup pins 
2. **Navatars:** Replaces the boring dot symbol for user's current location with avatars like Darth Vader, Batman, Hipster, etc
3. **My Location:** Centers the map around the user whenever pressed 
4. **Phone URL:**  Lets the user directly call the coffee shop
5. **Directions:**  Directly opens the maps app and shows directions to the coffeeshop
6. **Web URL:**  Opens the website for Coffee Shop in Safari

# Contributors:

### Artwork:
<img src="Espresso/Espresso/Assets.xcassets/batman.imageset/batman.png?" alt="alt text" width="50" height="50"> Icon made by http://www.flaticon.com/authors/tutsplus from www.flaticon.com

<img src="Espresso/Espresso/Assets.xcassets/coffeePin.imageset/coffee (2).png?" alt="alt text" width="50" height="50"> Icon made by www.flaticon.com/authors/freepik from www.flaticon.com

<img src="Espresso/Espresso/Assets.xcassets/ninja.imageset/ninja-portrait.png" alt="alt text" width="50" height="50"> Icon made by www.flaticon.com/authors/freepik from www.flaticon.com

<img src="Espresso/Espresso/Assets.xcassets/knight.imageset/knight.png?" alt="alt text" width="50" height="50"> Icon made by www.flaticon.com/authors/freepik from www.flaticon.com

<img src="Espresso/Espresso/Assets.xcassets/darthVader.imageset/dVader.png?" alt="alt text" width="50" height="50"> Icon made by https://www.iconfinder.com/milan.kohut

<img src="Espresso/Espresso/Assets.xcassets/hipster.imageset/hipster.png?" alt="alt text" width="50" height="50"> Icon made by http://www.flaticon.com/authors/madebyoliver from www.flaticon.com

### ThirdParty Libraries:
1. [Alamofire](https://github.com/Alamofire/Alamofire)
2. [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
3. [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper)
4. [RxSwift](https://github.com/ReactiveX/RxSwift)
5. [RxCocoa](https://github.com/ReactiveX/RxSwift)
6. [RxOptional](https://github.com/RxSwiftCommunity/RxOptional)
7. [CocoaPods](https://github.com/CocoaPods/CocoaPods)
