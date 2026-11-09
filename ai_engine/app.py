from flask import Flask, jsonify
import cv2
import numpy as np

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({
        "status": "success",
        "message": "Motor de IA de HoloWear (Python) en línea",
        "cv2_version": cv2.__version__,
        "numpy_version": np.__version__
    })

if __name__ == '__main__':
    # Usamos el puerto 5001 para no chocar con Node.js que está en el 5000
    app.run(debug=True, port=5001)