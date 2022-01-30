# NY-TimesNews

. Application to fetch NYTimes news from NYTimes public APIs.

. Application using MVVM-C architecture

. Add unit test and apply test cases.

. Open "https://developer.nytimes.com/" then create account so you will get your "api-key".

# Layers:

Domain Layer (Business logic) : without dependencies to other layers, it is totally isolated.

Presentation Layer contains UI (UIViewControllers or SwiftUI Views). Views are coordinated by ViewModels (Presenters) which execute one or many Use Cases. Presentation Layer depends only on the Domain Layer.

Data Layer contains Repository Implementations and one or many Data Sources. Repositories are responsible for coordinating data from different Data Sources.

![CleanArchWithMVVM](https://user-images.githubusercontent.com/28683024/151705597-9aa5b19e-b976-49a4-8415-ad4decf8e1d4.png)

# Architecture concepts used here

 . Clean Architecture https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html


# Application Architecture (MVVM+C)

## Scene
A scene can be thought of a section, feature, or use-case inside an app.

## What is a Coordinator?
This is the last part of this architecture’s name. 
A coordinator is an object (Class type in Swift) which has the sole responsibility, as it’s name implies, to coordinate the App’s navigation. Basically which screen should be shown, what screen should be shown next, etc.

This basically means that the coordinator has to:

Instantiate ViewController’s & ViewModel’s Instantiate & Inject dependencies into the ViewController’s and ViewModel’s Present or push ViewController’s onto the screen

## AppCoordinator

Your app should consist of multiple coordinators, one for each scene. But it should always have one “main” AppCoordinator, which will be owned by the App Delegate

![MVVM+C](https://user-images.githubusercontent.com/28683024/151711251-de9e801f-ad68-416f-9a0d-275631bf3e3c.png)
 
 ## Data Flow
1. App Scens owns the AppCoordinator and it can take a decsion which view will navigate to.
2. When start Appcoordinator it can intialize next view coordinator and inject it's depndencies (Each screen has it's coordinator)
3. When start view coordinator it will be responsible for instantiate view and inject it's dependecies.
1. View(UI) calls method from ViewModel (using combine for data binding)
2. ViewModel executes Use Case.
3. Use Case combines data from Repositories.
4. Each Repository returns data from a Remote Data (Network), Persistent DB Storage Source or In-memory Data (Remote or Cached).
5. Information flows back to the View(UI) where we display the list of items.



. Dependency Direction

Dependant: is a generic protocol using for dependcy injection 

# Requirements

. The application is being developed on Xcode Version 13.2.1, Swift 5.5.

# How to use app

Application to fetch NYTimes news from NYTimes public APIs for a week, can fetch news for day or month from upper filter, Can see details when select any.


