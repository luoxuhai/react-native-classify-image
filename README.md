<div align="center">
  <h1 align="center">🏞 React Native Classify Image</h1>
  <h3 align="center">React-native library to classify images using Vision.</h3>
</div>

English | [简体中文](./README-zh_CN.md)

<img style="width: 50%;margin: 0 auto;" src="https://s4.ax1x.com/2022/01/15/7JJaDI.png" />

For the identification result, the larger the value of `confidence` (confidence, a decimal in the [0 - 1] interval), the higher the confidence.

````js
[
  {
    identifier: {
      en: "animal",
      zh_cn: "动物"
    },
    confidence: 0.848;
  },
  {
    identifier: {
      en:  "cat",
      zh_cn: "猫"
    },
    confidence: 0.848;
  },
  {
    identifier: {
      en: "clothing",
      zh_cn: "衣服"
    },
    confidence: 0.676;
  },
  {
    identifier: {
      en: "hat",
      zh_cn: "帽子"
    },
    confidence: 0.631;
  },
  ...
]
````

## ❗️ :warning:

Currently only supports iOS 13.0+

## Installation

`$ npm install react-native-classify-image --save`

or

`$ yarn add react-native-classify-image`

````sh
# RN >= 0.60
cd ios && pod install
# RN < 0.60
react-native link react-native-classify-image
````

## Usage

### Basic usage

````js
import * as ClassifyImage from 'react-native-classify-image';

ClassifyImage.request(path) // Local path
  .then((result) => {
    // success
  })
  .catch((error) => {
    // error
  });
````

### Advanced usage

````js
import * as ClassifyImage from 'react-native-classify-image';
import RNFS from 'react-native-fs';

const path = `${RNFS.TemporaryDirectoryPath}/IMG_1234.jpg`;

// https://github.com/itinance/react-native-fs
RNFS.downloadFile({
  fromUrl: 'https://s4.ax1x.com/2022/01/15/7JJaDI.png',
  toFile: path,
}).promise.then((res) => {
  ClassifyImage.request(path, {
    minConfidence: 0.6,
    orientation: ClassifyImage.Orientation.Up,
  })
    .then((result) => {
      // success
    })
    .catch((error) => {
      // error
    });
});
````

## API

### `request(path: string, options?: Object): Promise<Result[]>`

| Name               | Type   | Description                                                                                                                   |
| ------------------ | ------ | ---------------------------------------------------------------------------------------------------------------------- |
| **path**           | string | Local absolute path to the image file. Available with [react-native-fs constants](https://github.com/itinance/react-native-fs#constants) |
| **options** (Optional) | object | See below `Options`             

### `supportedIdentifiers(): Promise<string[]>`

### Options

| Name                                  | Type    | Description                                                                                                   | Default           |
| ------------------------------------- | ------- | ------------------------------------------------------------------------------------------------------ | ---------------- |
| **minConfidence** (Optional)              | string  | Minimum confidence, only return data greater than or equal to this value. Ranges:[0-1]                                                   | 0.1              |
| **preferBackgroundProcessing** (Optional) | boolean | If set to `true`, this property reduces the request's memory footprint, processing footprint, and CPU/GPU contention, but may take longer to execute. | false            |
| **usesCPUOnly** (Optional)                | boolean | Execute on CPU only. Setting `false` means that the GPU is free to use the GPU to speed up its processing.                  | false            |
| **orientation** (Optional)                | number  | Image orientation                                                                                             | `Orientation.Up` |


### Result - recognition result

| Name | Type | Description |
| -------------- | ------ | --------------- |
| **identifier** | object | Category label name |
| **confidence** | number | confidence, [0 - 1] |

### Orientation

- `Orientation.Up`: `1` - default orientation
- `Orientation.UpMirrored`: `2` - flip horizontally
- `Orientation.Down`: `3` - rotate 180°
- `Orientation.DownMirrored`: `4` - vertical flip
- `Orientation.Left`: `5` - Flip horizontally and rotate 90° counterclockwise
- `Orientation.LeftMirrored`: `6` - rotate 90° clockwise
- `Orientation.Right`: `7` - Flip horizontally and rotate 90° clockwise
- `Orientation.RightMirrored`: `8` - rotate 90° clockwise

## Troubleshooting

1. Check your minimum iOS version. react-native-classify-image requires a minimum iOS version of 11.0 (currently only supports iOS 13.0+).
   - Open your Podfile
   - Make sure `platform :ios` is set to 11.0 or higher
   - Make sure `iOS Deployment Target` is set to 11.0 or higher
2. Make sure you have created a Swift bridging header in your project.
   - Open your project with Xcode (**xxx.xcworkspace**)
   - Follow these steps to create a Swift file **File > New > File (⌘+N)**
   - Select **Swift File** and click **Next**
   - Enter the file name **BridgingFile.swift**, then click Create, click **Create Bridging Header** when prompted

## TODO

- [ ] Support Android
- [ ] Support to identify the specified area
- [ ] Support web images

## License

MIT