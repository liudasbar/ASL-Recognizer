![Logo](https://github.com/liudasbar/ASL-Recognizer/blob/main/ASL-Recognizer/Resources/ForReadMe/App-Icon-150.png)
# ASL Recognizer - Sign Language Recognition with Camera

ASL Recognizer project is an open-source project designed to showcase hand pose detection by using iOS device camera. The project is fully open-source and [documented](https://github.com/liudasbar/ASL-Recognizer) on GitHub, and can be accessed by anyone.

![Image](https://github.com/liudasbar/ASL-Recognizer/blob/main/ASL-Recognizer/Resources/ForReadMe/IMG_0123_700.PNG)

![Image](https://github.com/liudasbar/ASL-Recognizer/blob/main/ASL-Recognizer/Resources/ForReadMe/IMG_0124_700.PNG)

## Features and Datasets

The application uses __American Sign Language (ASL)__ ML recognition model that is was organized, trained, and tested via Xcode Create ML tools.

While the developer does not provide any related data sets, it is worth mentioning that the data set for this specific application consists of images (that were used for training and validation of an aforementioned ML model) gathered from various sources found on the internet varying from ASL learning YouTube videos to publicly available ASL hand poses images data sets.

## What can be recognized?

ASL Recognizer detects only alphabet letters A-Z and numbers from 0-9. Hand pose detection output is shown within the main application interface. Each detected symbol (letter or number) is added to the current value with previously detected symbols.

## Abbreviations

ASL - American Sign Language

ML - Machine Learning

## Availability

The project is written on Xcode 13 for iOS/iPadOS devices from iOS 14.

## Recognition model

Accuracy:
* Training - 96 %
* Validation - 88 %

Training data:
* 36 classes
* 11 128 items

## Privacy permissions

User needs to grant these privacy permissions:
* Camera - Used for detecting and recognizing hand poses.

## Offline

ASL Recognizer is fully offline. Thus, no data is being sent or received to and from any server. Data collection is not implemented in any way.

## Privacy Policy and support

If you have questions regarding this application or its support, please [contact](mailto:liudasbar2@gmail.com) the developer.

## Updates

Change Log is not available yet.

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
