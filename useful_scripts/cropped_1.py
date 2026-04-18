#!/usr/bin/env python3

import cv2
import numpy as np
import sys

def crop_text_area(image_path, output_path, margin=30):
    img = cv2.imread(image_path)
    if img is None:
        print(f"エラー: 画像が見つかりません ({image_path})")
        exit(1)

    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    binary = cv2.adaptiveThreshold(gray, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, 
                                   cv2.THRESH_BINARY_INV, 21, 14)

    row_sum = np.sum(binary, axis=1)
    col_sum = np.sum(binary, axis=0)

    h, w = img.shape[:2]
    rows_threshold = 255 * (w * 0.004)
    cols_threshold = 255 * (h * 0.004)
    rows = np.where(row_sum > rows_threshold)[0]
    cols = np.where(col_sum > cols_threshold)[0]

    if len(rows) > 0 and len(cols) > 0:
        y_min, y_max = rows[0], rows[-1]
        x_min, x_max = cols[0], cols[-1]

        y1 = max(0, y_min - margin)
        y2 = min(h, y_max + margin)
        x1 = max(0, x_min - margin)
        x2 = min(w, x_max + margin)

        cropped = img[y1:y2, x1:x2]
        cv2.imwrite(output_path, cropped)
        # print(f"Saved: {output_path} (Size: {x2-x1}x{y2-y1})")
    else:
        print("文字領域を検出できませんでした")
        exit(1)

if __name__ == "__main__":
    if len(sys.argv) >= 3:
        crop_text_area(sys.argv[1], sys.argv[2], margin=30)