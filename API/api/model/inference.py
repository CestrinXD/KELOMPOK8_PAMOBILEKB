import numpy as np
import pandas as pd
import pickle
import joblib
import tensorflow as tf
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler, MinMaxScaler, OneHotEncoder
from sklearn.compose import ColumnTransformer
from PIL import Image

class Model:
    def __init__(self, model_path):
        if model_path.endswith('.pkl'):
            with open(model_path, 'rb') as f:
                self.model = pickle.load(f)
            self.model_type = 'sklearn'
        elif model_path.endswith('.joblib'):
            self.model = joblib.load(model_path)
            self.model_type = 'sklearn'
        elif model_path.endswith('.h5'):
            self.model = tf.keras.models.load_model(model_path)
            self.model_type = 'keras'
        elif model_path.endswith('.tflite'):
            self.model = tf.lite.Interpreter(model_path=model_path)
            self.model.allocate_tensors()
            self.model_type = 'tflite'
        else:
            raise ValueError(f"Model format '{model_path.split('.')[-1]}' not supported. Please use '.pkl', '.joblib', '.h5', or '.tflite'.")

    def data_pipeline(self, numerical_features=None, categorical_features=None, scaler_type="standard"):
        if self.model_type != 'sklearn':
            raise ValueError("Data pipeline is only supported for scikit-learn models.")

        # Preprocessor untuk data numerik dan kategorikal
        preprocessor = ColumnTransformer(
            transformers=[
                ('num', StandardScaler(), ['HTGD', 'ATGD', 'HTP', 'ATP', 'DiffFormPts']),  # Fitur numerik
                ('cat', OneHotEncoder(sparse_output=False), ['HM1', 'HM2', 'HM3', 'AM1', 'AM2', 'AM3'])  # Fitur kategorikal
            ],
            remainder="passthrough"
        )

        pipeline = Pipeline([
            ('preprocessor', preprocessor),
            ('classifier', self.model)
        ])

        return pipeline

    # def predict_from_image(self, image_file):
    #     '''
    #     Terkhusus preprocessing basic seperti resize, rescale dan convert grayscale bisa dilakukan di sini.
    #     ika preprocessing yang dibutuhkan lebih kompleks, 
    #     sebaiknya dilakukan di method `data_pipeline` dan dipanggil di method ini.
    #     Tidak ada batasan dalam preprocessing, sesuaikan dengan kebutuhan model. 
    #     Yang terdapat pada contoh ini adalah preprocessing untuk model MNIST.
    #     '''
    #     image = Image.open(image_file).convert('L')
    #     image = image.resize((224, 224))
    #     image_array = np.array(image) / 255.0

    #     if image_array.ndim == 2: 
    #         # Menurunkan dimensi array menjadi 1D
    #         image_array = image_array.reshape(-1, 784)
    #         # Menaikkan dimensi array menjadi 3D
    #         # image_array = np.expand_dims(image_array, axis=0)

    #     if self.model_type == 'keras':
    #         prediction = self.model.predict(image_array)
    #         prediction = np.argmax(prediction, axis=1)
    #         return prediction.tolist()

    #     elif self.model_type == 'tflite':
    #         input_details = self.model.get_input_details()
    #         output_details = self.model.get_output_details()
            
    #         image_array = image_array.astype(input_details[0]['dtype'])
    #         self.model.set_tensor(input_details[0]['index'], image_array)
    #         self.model.invoke()
    #         prediction = self.model.get_tensor(output_details[0]['index'])
    #         return prediction.tolist()
        
    #     else:
    #         raise ValueError("This method is only supported for Keras and TensorFlow Lite models.")

    def predict_from_data(self, data, numerical_features=None):
        if self.model_type == 'sklearn':
            if isinstance(data, (list, np.ndarray)):
                # data = pd.DataFrame(data)   
                data = pd.DataFrame([data], columns=["HTGD", "ATGD", "HTP", "ATP", "DiffFormPts", "HM1", "HM2", "HM3", "AM1", "AM2", "AM3"])

            elif not isinstance(data, pd.DataFrame):
                raise ValueError("Data format not supported for sklearn model. Use list, NumPy array, or DataFrame.")
            
            # predict pake persentase home vs away
            prediction = self.model.predict_proba(data)  

            return prediction

        
    @staticmethod
    def from_path(model_path):
        return Model(model_path)
