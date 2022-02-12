import { NativeModules } from 'react-native';

import identifiers from './identifiers.json';

const { ClassifyImage } = NativeModules;

export enum Orientation {
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

interface BaseResult {
  /**
   * 分类标签名
   */
  identifier: any;
  /**
   * 置信度，[0 - 1]
   */
  confidence: number;
}

export interface Result extends BaseResult {
  /**
   * 分类标签名
   */
  identifier: {
    en: string;
    zh_cn: string;
  };
}

/**
 * 请求图像分类
 *
 * @async
 * @param path 图像本地路径
 * @param options 配置
 */
export async function request(
  path: string,
  options?: Options
): Promise<Result[]> {
  return ClassifyImage.request({
    path,
    ...options,
  }).then((results: BaseResult[]) => {
    return results?.map((item) => {
      const identifier = (identifiers as { [key: string]: any })[
        item.identifier
      ];

      return {
        ...item,
        identifier: {
          en: identifier?.en ?? item.identifier,
          zh_cn: identifier?.zh_cn,
        },
      };
    });
  });
}

/**
 * 支持的标识符
 *
 * @async
 * @returns 返回请求在其当前配置中支持的分类标识符。
 */
export function supportedIdentifiers(): Promise<string[]> {
  return ClassifyImage.supportedIdentifiers();
}
