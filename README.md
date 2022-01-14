# react-native-classify-image

使用 Vision 对图像进行分类的 react-native 库 | react-native library to classify images using Vision

<img style="width: 50%;margin: 0 auto;" src="https://s4.ax1x.com/2022/01/15/7JJaDI.png" />

识别结果，值越大可信度越高（[0 - 1]区间内的小数）

```js
{
  animal: 0.848, // 动物
  cat: 0.823, // 猫
  mammal: 0.811, // 哺乳动物
  clothing: 0.676, // 衣服
  beanie: 0.645, // 小圆帽
  hat: 0.631, // 帽子
  people: 0.616), // 人
  ...
 }
```

## ❗️ :warning:

目前仅支持 iOS 13.0+

## Installation

`$ npm install react-native-classify-image --save`

or

`$ yarn add react-native-classify-image`

```sh
# RN >= 0.60
cd ios && pod install
# RN < 0.60
react-native link react-native-classify-image
```

## Usage

### 简单使用

```js
import * as ClassifyImage from 'react-native-classify-image';

ClassifyImage.request(path) // 绝对本地路径
  .then((result) => {
    // success
  })
  .catch((error) => {
    // error
  });
```

### 高级使用 (使用网络图像)

```js
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
      console.log(result);
      // { animal: 0.848, cat: 0.848, mammal: 0.848, clothing: 0.676, beanie: 0.675, hat: 0.675, people: 0.616), ... }
    })
    .catch((error) => {
      // error
    });
});
```

## API

### `request(path: string, options?: Object): Promise<{[key: string]: number}[]>`

| Parameter          | Type   | Description                                                                                                            |
| ------------------ | ------ | ---------------------------------------------------------------------------------------------------------------------- |
| **path**           | string | 图像文件的本地绝对路径. 可使用 [react-native-fs constants](https://github.com/itinance/react-native-fs#constants) 获取 |
| **options** (可选) | Object | 可选项，见下 `Options`                                                                                                 |

### Options

| Parameter                             | Type    | Description                                                                                            | Default value    |
| ------------------------------------- | ------- | ------------------------------------------------------------------------------------------------------ | ---------------- |
| **minConfidence** (可选)              | string  | 最小置信度，仅返回大于等于该值的数据。取值范围:[0-1]                                                   | 0.1              |
| **preferBackgroundProcessing** (可选) | boolean | 如果设置为 `true`，则此属性会减少请求的内存占用、处理占用和 CPU/GPU 争用，但可能会花费更长的执行时间。 | false            |
| **usesCPUOnly** (可选)                | boolean | 仅在 CPU 上执行。设置 `false` 表示可以自由地利用 GPU 来加速其处理。                                    | false            |
| **orientation** (可选)                | boolean | 图像的方向                                                                                             | `Orientation.Up` |

### Orientation

- `Orientation.Up`: `1` - 默认方向
- `Orientation.UpMirrored`: `2` - 水平翻转
- `Orientation.Down`: `3` - 旋转 180°
- `Orientation.DownMirrored`: `4` - 垂直翻转
- `Orientation.Left`: `5` - 水平翻转并逆时针旋转 90°
- `Orientation.LeftMirrored`: `6` - 顺时针旋转 90°
- `Orientation.Right`: `7` - 水平翻转并顺时针旋转 90°
- `Orientation.RightMirrored`: `8` - 顺时针旋转 90°

## Troubleshooting

1. 检查您的最低 iOS 版本。react-native-classify-image 要求最低 iOS 版本为 11.0（目前仅支持 iOS 13.0+ 使用）。
   - 打开你的 Podfile
   - 确保 `platform :ios` 设置为 11.0 或更高
   - 确保 `iOS Deployment Target` 设置为 11.0 或更高
2. 确保您在项目中创建了 Swift 桥接头。
   - 使用 Xcode 打开你的项目（**xxx.xcworkspace**）
   - 按照以下步骤创建 Swift 文件 **File > New > File (⌘+N)**
   - 选择 **Swift File** 并点击 **Next**
   - 输入文件名 **BridgingFile.swift**，然后点击创建，提示时点击 **Create Bridging Header**

## TODO

- [ ] 支持 iOS 11.0+（使用 MobileNet）
- [ ] 支持识别指定区域

## License

MIT
