![Logo](https://github.com/liudasbar/ASL-Recognizer/blob/main/ASL-Recognizer/Resources/ForReadMe/App_Icon_150.png)
# ASL Recognizer - Sign Language Recognition with Camera

__Easily identify Sign Language alphabet letters (A-Z) or numbers (0-9) hand gestures with the use of your device camera!__

![Image](https://github.com/liudasbar/ASL-Recognizer/blob/main/ASL-Recognizer/Resources/ForReadMe/ASLRecognizerAppShowcase_2048.png)

### SMART RECOGNITION
ASL Recognizer uses machine learning based model that is trained for high accuracy detection in any environment.

### UNIVERSAL
Identify world’s most recognizable sign language basic gestures.

### MAKE WORDS
By recognizing each hand pose, you can combine whole words to understand what is being said in sign language.

### LEARN SIGN LANGUAGE BASICS
Find all basic alphabet American Sign Language gestures in one place for easier identification and learning.

### FOR DEVELOPERS
The project uses Combine, AVFoundation, SwiftGen and Apple Vision frameworks, is wrapped around Clean Swift VIP architecture and is fully open-source [documented](https://github.com/liudasbar/ASL-Recognizer) on GitHub.

[![Download on the App Store](https://github.com/liudasbar/ASL-Recognizer/blob/main/ASL-Recognizer/Resources/ForReadMe/Download_on_the_App_Store_Badge_US_180px.png)](https://apps.apple.com/us/app/asl-recognizer/id1612140503)

## Features and Data Sets

The application uses __American Sign Language (ASL)__ machine learning based recognition model that is organized, trained, and tested via Xcode Create ML tools.

While the developer does not provide any related data sets, it is worth mentioning that the data set for this specific ML model that application uses consists of images (that were used for training and validation of an aforementioned ML model) gathered from various sources found on the internet varying from ASL learning YouTube videos to publicly available ASL hand poses images data sets.

## What can be recognized?

__ASL Recognizer detects only alphabet letters A-Z and numbers from 0-9__. Hand gesture detection output is shown within the main application interface. Each detected symbol (letter or number) is added to the current value with previously detected symbols.

## Availability

The project is written on Xcode 13 __for iOS/iPadOS devices from iOS 14__.

## ML model

Accuracy:
* Training - 95 %
* Validation - 86 %

Training data:
* 36 classes
* 11 897 items

⚠️ __It should be noted that detection of some letters is not ideal and may lead to letters being recognized as not the right ones. The ML model is set to be improved.__

## Prediction based on ML model from technical perspective

The application uses __Apple Vision__ framework to perform the hand gesture recognition with each camera output frame (__CMSampleBuffer__). Vision has hand pose visual detection request class that is used for hand pose and fingers recognition. Vision data parsing goes through __VNImageRequestHandler__.

Hand Pose ML model to predict a hand gesture uses __MLMultiArray__ as input. What is amazing here is that multi-dimensional array (__MLMultiArray__) can be extracted from Vision image request handler (__VNImageRequestHandler__) output directly, which then is passed to model prediction methods (they were generated directly in Xcode's Create ML application before).

Finally, after model finishes with prediction, the following can be extracted: prediction confidence, predicted result (label), and many more!

## Error handling

The following errors/issues are handled (if occur - may provide an error message visually):
* No hand gesture found.
* Hand gesture prediction failure.
* Various camera input, output, preview layer setup errors.
* Critical thermal state condition.

## Project architecture

Project relies on __Clean VIP architecture__ (with own project modifications). Please find VIP architecture example scheme below:

![Image](https://user-images.githubusercontent.com/5277297/60242511-716cfc00-98d3-11e9-8e1f-709230093433.png)

More about this specific architecture __[here](https://github.com/bhardwajpankaj/VIP)__.

Additionally, the project uses a little bit of Combine framework to simplify some of the asynchronous actions.

## Privacy permissions

User needs to grant these privacy permissions:
* Camera - Used for detecting and recognizing hand poses.

## Offline

ASL Recognizer is fully offline. Thus, no data is being sent or received to and from any server. Data collection is not implemented in any way.

## Abbreviations

__ASL__ - American Sign Language

__ML__ - Machine Learning

## Privacy Policy and support

If you have questions regarding this application or its support, please [contact](mailto:liudasbar2@gmail.com) the developer.

## Updates

Change Log is not available yet.

## Setting up the project

1. Open project directory via Terminal:
```
cd project/directory
```
2. Install pods:
```
pod install
```
3. Open __ASL-Recognizer.xcworkspace__ file.

## App icon

App icon has been designed using resources from [Flaticon.com](https://www.flaticon.com/premium-icon/peace_3211565?related_id=3211565).

## License

MIT License

__Copyright © 2022 Liudas Baronas.__

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
