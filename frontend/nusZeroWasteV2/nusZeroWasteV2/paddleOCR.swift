//
//  paddleOCR.swift
//  nusZeroWasteV2
//
//  Created by Beng Beng on 4/9/24.
//

import PythonKit

let sys = Python.import("sys")
let paddleocr = Python.import("paddleocr")

// Assuming you have bundled PaddleOCR correctly
let ocr = paddleocr.PaddleOCR(use_angle_cls: true)
let result = ocr.ocr("path_to_image")
print(result)

