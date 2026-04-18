#!/usr/bin/env python3

import cv2
import numpy as np
import sys
import warnings
warnings.filterwarnings("ignore")
from skimage import measure, morphology

def crop_text_area(image_path, output_path, margin=40):
    img = cv2.imread(image_path)
    if img is None:
        print(f"エラー: 画像が見つかりません ({image_path})")
        exit(1)

    h, w = img.shape[:2]
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    binary = cv2.adaptiveThreshold(gray, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, 
                                   cv2.THRESH_BINARY_INV, 25, 10)

    binary_cleaned = morphology.remove_small_objects(binary.astype(bool), 100)

    label_image = measure.label(binary_cleaned)
    
    regions = measure.regionprops(label_image)

    all_min_r, all_min_c, all_max_r, all_max_c = [], [], [], []
    
    area_threshold = (h * w) * 0.0001 

    for region in regions:
        if region.area > area_threshold:
            min_r, min_c, max_r, max_c = region.bbox
            all_min_r.append(min_r)
            all_min_c.append(min_c)
            all_max_r.append(max_r)
            all_max_c.append(max_c)

    if all_min_r:
        y_min, y_max = min(all_min_r), max(all_max_r)
        x_min, x_max = min(all_min_c), max(all_max_c)

        y1 = max(0, y_min - margin)
        y2 = min(h, y_max + margin)
        x1 = max(0, x_min - margin)
        x2 = min(w, x_max + margin)

        cropped = img[y1:y2, x1:x2]
        cv2.imwrite(output_path, cropped)
        # print(f"Saved (skimage): {output_path} ({x2-x1}x{y2-y1})")
    else:
        print(f"文字を検出できませんでした: {image_path}")
        cv2.imwrite(output_path, img)

if __name__ == "__main__":
    if len(sys.argv) >= 3:
        crop_text_area(sys.argv[1], sys.argv[2], margin=40)
