import { NativeModules } from 'react-native';

const { ClassifyImage } = NativeModules;

export const enum Orientation {
  /** 默认方向 */
  Up = 1,
  /** 水平翻转 */
  UpMirrored = 2,
  /**  旋转 180° */
  Down = 3,
  /** 垂直翻转 */
  DownMirrored = 4,
  /** 水平翻转并逆时针旋转 90° */
  Left = 5,
  /** 顺时针旋转 90° */
  LeftMirrored = 6,
  /** 水平翻转并顺时针旋转 90° */
  Right = 7,
  /** 顺时针旋转 90° */
  RightMirrored = 8,
}

export interface Options {
  /**
   * 最小置信度，仅返回大于等于该值的数据。
   * @description 取值范围：[ 0 - 1 ]
   * @default 0.1
   **/
  minConfidence?: number;
  /**
   * 如果设置为true，则此属性会减少请求的内存占用、处理占用和 CPU/GPU 争用，但可能会花费更长的执行时间。
   * @default false
   **/
  preferBackgroundProcessing?: boolean;
  /**
   * 仅在 CPU 上执行。
   * @default false
   **/
  usesCPUOnly?: boolean;
  /**
   * 图像的方向
   * @default Up
   **/
  orientation?: Orientation;
}

/**
 * 请求图像分类
 *
 * @async
 * @param path 图像本地路径
 * @param options 配置
 */
export function request(
  path: string,
  options?: Options
): Promise<Record<string, number>> {
  return ClassifyImage.request({
    path,
    ...options,
  });
}
