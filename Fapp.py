from flask import Flask, request, jsonify
import pickle
import numpy as np
from sklearn.preprocessing import LabelEncoder
from sklearn.impute import SimpleImputer
from sklearn.neighbors import KNeighborsRegressor

# Load the model
model = pickle.load(open('model.pkl', 'rb'))

# Initialize the Flask application
app = Flask(__name__)

# Define label encoders for categorical variables if needed
airline_encoder = LabelEncoder()
source_encoder = LabelEncoder()
dest_encoder = LabelEncoder()
stops_encoder = LabelEncoder()
info_encoder = LabelEncoder()

# Fit the encoders with the training data (assuming these are the training values)
# Replace these with your actual training data
airline_encoder.fit(['Airline1', 'Airline2', 'Airline3'])  # Replace with actual airlines
source_encoder.fit(['Source1', 'Source2', 'Source3'])  # Replace with actual sources
dest_encoder.fit(['Dest1', 'Dest2', 'Dest3'])  # Replace with actual destinations
stops_encoder.fit(['0 stops', '1 stop', '2 stops'])  # Replace with actual stops categories
info_encoder.fit(['Info1', 'Info2', 'Info3'])  # Replace with actual additional info categories

@app.route('/')
def home():
    return "Hello world"

@app.route('/predict', methods=['POST'])
def predict():
    # Extract features from the request
    airline = request.form.get('Airline')
    source = request.form.get('Source')
    dest = request.form.get('Destination')
    stops = request.form.get('Total_Stops')
    info = request.form.get('Additional_Info')
    date = request.form.get('Date')
    month = request.form.get('Month')
    year = request.form.get('Year')
    arrival_hour = request.form.get('Arrival_hour')
    arrival_min = request.form.get('Arrival_min')
    dept_hour = request.form.get('Dept_hour')
    dept_min = request.form.get('Dept_min')
    duration_hour = request.form.get('duration_hour')

    # Convert categorical variables using the safe_transform function
    def safe_transform(encoder, label):
        if label in encoder.classes_:
            return encoder.transform([label])[0]
        else:
            # Handle unseen labels
            return -1  # or any default value indicating an unknown category

    airline_encoded = safe_transform(airline_encoder, airline)
    source_encoded = safe_transform(source_encoder, source)
    dest_encoded = safe_transform(dest_encoder, dest)
    stops_encoded = safe_transform(stops_encoder, stops)
    info_encoded = safe_transform(info_encoder, info)

    # Initialize SimpleImputer for handling missing values
    imputer = SimpleImputer(strategy='mean')

    # Preprocess the numerical features
    numerical_features = [date, month, year, arrival_hour, arrival_min, dept_hour, dept_min, duration_hour]
    numerical_features = np.array(numerical_features, dtype=float)  # Convert to float for imputation
    numerical_features = np.nan_to_num(numerical_features)  # Convert NaNs to zeros for compatibility with SimpleImputer

    # Fit the imputer on the numerical features
    imputer.fit([numerical_features])

    # Impute missing values
    numerical_features_imputed = imputer.transform([numerical_features])

    # Combine categorical and numerical features
    input_features = np.array([airline_encoded, source_encoded, dest_encoded, stops_encoded, info_encoded])

    # Reshape numerical_features_imputed to have compatible dimensions
    numerical_features_imputed = numerical_features_imputed.ravel()

    # Concatenate numerical_features_imputed with input_features along axis 0
    input_features = np.concatenate([input_features, numerical_features_imputed], axis=0)

    # Reshape input_features to have compatible shape for concatenation
    input_features = input_features.reshape(1, -1)

    # Make prediction
    result = model.predict(input_features)[0]
    
    print(result)

    return jsonify({'price': result})

if __name__ == '__main__':
    app.run(debug=True)
