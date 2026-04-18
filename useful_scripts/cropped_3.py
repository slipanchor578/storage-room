#!/usr/bin/env python3

import cv2
import pytesseract
import sys

def crop_text_area(image_path, output_path, margin=40):
    # 画像の読み込み
    img = cv2.imread(image_path)
    if img is None:
        print(f"エラー: 画像が見つかりません ({image_path})")
        exit(1)

    h, w = img.shape[:2]

    try:
        data = pytesseract.image_to_data(img, lang='jpn+eng', output_type=pytesseract.Output.DICT, config='--psm 3')
    except Exception as e:
        print(f"OCR実行エラー: {e}")
        exit(1)

    x_coords = []
    y_coords = []

    for i in range(len(data['text'])):
        if int(data['conf'][i]) > 10 and data['text'][i].strip():
            x = data['left'][i]
            y = data['top'][i]
            width = data['width'][i]
            height = data['height'][i]
            
            x_coords.append(x)
            x_coords.append(x + width)
            y_coords.append(y)
            y_coords.append(y + height)

    if x_coords and y_coords:
        x_min, x_max = min(x_coords), max(x_coords)
        y_min, y_max = min(y_coords), max(y_coords)

        # マージンを考慮
        y1 = max(0, y_min - margin)
        y2 = min(h, y_max + margin)
        x1 = max(0, x_min - margin)
        x2 = min(w, x_max + margin)

        cropped = img[y1:y2, x1:x2]
        cv2.imwrite(output_path, cropped)
        # print(f"Saved (OCR): {output_path} (Size: {x2-x1}x{y2-y1})")
    else:
        print(f"文字を検出できませんでした（スキップ）: {image_path}")
        cv2.imwrite(output_path, img)

if __name__ == "__main__":
    if len(sys.argv) >= 3:
        crop_text_area(sys.argv[1], sys.argv[2], margin=40)
