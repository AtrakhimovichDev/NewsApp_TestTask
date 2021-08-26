# Newvy
Newvy is a simple, test news application.

## Tech
Xcode version - 12.5  
iOS version - 14.5

- UIKit
- [Cocoapods](https://cocoapods.org/) 1.10.2
- [Alamofire](https://github.com/Alamofire/Alamofire) 5.4.3

## Installation

Install the dependencies.

```sh
cd 'path to project'
pod install
```

> Note: if you have Ь1 processor you may have problems with pods instalation. If you are faced with it, try this
`arch -x86_64 pod install`

App use free news api [Newapi.org](https://newsapi.org/). If you want to run some tests, you need to generate your API key.
And then paste it in next place:

```sh
static private var apiKey = ""
```
This variable is in the `NetworkRequestManager.swift` file.
