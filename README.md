## (a) Summary of presentation introduction

AddEZ is an app that computes various matrix operations, providing quick and easy access to solutions and steps for complicated matrix calculations. Our tool allows users to compute many linear algebra and calculus features, including:

Linear Algebra Features
- Reduced Row-Echelon Form
- Inverse
- Determinant
- Eigenvalue

Calculus Features
- Function Parsing and Graphing
- Reimann Sum
- Differentiation

AddEZ is an alternative to existing software such as Symbolab. AddEZ is better than these in a few key ways. Firstly, our tool provides all the steps to solving the specified input problem for free, which Symbolab does not do. Moreover, our tool has a far more flexible parser than PrairieLearn (ex. AddEZ allows for coefficients while PrairieLearn does not).

## (b) Describes technical architecture

AddEZ has 3 main components--the Landing Page, Matrix Model and Calculus Model.

The Landing Page acts as the first page the user sees when entering the app, and allows them to navigate the app. It connects to the matrix and calculus model and was written in Swift and used the SwiftUI Library.

The Matrix Model performs computations on matrices. It is independent of other components within the app and was written in Swift. No libraries or API's were used.

The Calculus Model graphs functions and computes integrals and derivatives. It is independent of all other components and was written in Swift. It uses the Neumorphic, Charts, Latex and SwiftUI libraries.

## (c) Provides reproducible installation instructions 

Clone the repository onto an Apple desktop machine and open it in Xcode. Connect an Apple mobile device (iPhone or iPad) to the desktop machine via a physical wire. Turn on developer mode on your mobile device: go to Settings -> Privacy and Security -> Scroll all the way to the bottom and toggle the 'Developer Mode' Switch -> Restart the device. Once the mobile device is restarted, download it via Xcode on the desktop machine. Once you open the app on the mobile device, it will prompt you to trust the developer. To trust the developer, go to Settings -> General -> VPN and Device Management -> Under 'Developer App', look for the app associated with your Xcode email -> tap it (the AddEZ logo should appear) and trust the developer.

We intend to put a more finalized version of the app on Apple's App Store. Then, the installation process is as easy as with any other app!

## (d) Group members and their roles

Ayush Raman - Full Stack Developer\
Sanjay Manoj - Backend Developer\
Spencer Sadler - Backend Developer\
Anish Cherukuthota - Testing
