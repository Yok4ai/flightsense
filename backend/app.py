#######

# from flask import Flask, jsonify
# import requests

# app = Flask(__name__)

# # Replace with your actual API key
# API_KEY = "2eb4dd9632msh030756d81822a53p1bcb51jsn1200cff31b06"

# @app.route("/flights/<query>")
# def search_flights(query):
#   url = "https://sky-scanner3.p.rapidapi.com/flights/auto-complete"
#   params = {"query": query}
#   headers = {
#       'X-RapidAPI-Key': API_KEY,
#       'X-RapidAPI-Host': "sky-scanner3.p.rapidapi.com"
#   }

#   response = requests.get(url, params=params, headers=headers)

#   # Check for successful response
#   if response.status_code == 200:
#     return jsonify(response.json())
#   else:
#     return f"Error: {response.status_code}", response.status_code

# if __name__ == "__main__":
#   app.run(debug=True)


########



# from flask import Flask, request, jsonify
# import requests

# app = Flask(__name__)

# @app.route('/flights/search-everywhere', methods=['GET'])
# def search_flights():

#     fromEntityId = request.args.get('fromEntityId')
#     cabin_class = request.args.get('cabinClass')  # Default to premium_economy

#     # Replace with your actual RapidAPI key
#     headers = {
#         "X-RapidAPI-Key": "2eb4dd9632msh030756d81822a53p1bcb51jsn1200cff31b06",
#         "X-RapidAPI-Host": "sky-scanner3.p.rapidapi.com"
#     }

#     # Construct the Skyscanner API URL dynamically based on origin
#     url = "https://sky-scanner3.p.rapidapi.com/flights/search-everywhere"

#     querystring = {"fromEntityId": fromEntityId, "cabinClass": cabin_class}

#     try:
#         response = requests.get(url, headers=headers, params=querystring)
#         response.raise_for_status()  # Raise an exception for non-200 status codes
#         return jsonify(response.json())
#     except requests.exceptions.RequestException as e:
#         print(f"An error occurred: {e}")
#         return jsonify({'error': 'An error occurred during the API request'}), 500

# if __name__ == '__main__':
#     app.run(debug=True)

###########



# from flask import Flask, jsonify, request
# import requests

# app = Flask(__name__)

# # Replace with your actual RapidAPI key
# API_KEY = "2eb4dd9632msh030756d81822a53p1bcb51jsn1200cff31b06"

# @app.route("/flights/search-everywhere", methods=['GET'])
# def search_everywhere():
#     from_entity_id = request.args.get('fromEntityId')
#     to_entity_id = request.args.get('toEntityId')
#     depart_Date = request.args.get('departDate') 
#     cabin_class = request.args.get('cabinClass')  # Default to premium_economy

#     url = "https://sky-scanner3.p.rapidapi.com/flights/search-everywhere"
#     headers = {
#         "X-RapidAPI-Key": API_KEY,
#         "X-RapidAPI-Host": "sky-scanner3.p.rapidapi.com"
#     }

#     querystring = {"fromEntityId": from_entity_id, "toEntityId": to_entity_id, "cabinClass": cabin_class, "departDate": depart_Date}

#     try:
#         response = requests.get(url, headers=headers, params=querystring)
#         response.raise_for_status()  # Raise an exception for non-200 status codes
#         return jsonify(response.json())
#     except requests.exceptions.RequestException as e:
#         print(f"An error occurred: {e}")
#         return jsonify({'error': 'An error occurred during the API request'}), 500

# @app.route("/flights/<query>")
# def search_flights(query):
#   url = "https://sky-scanner3.p.rapidapi.com/flights/auto-complete"
#   params = {"query": query}
#   headers = {
#       'X-RapidAPI-Key': API_KEY,
#       'X-RapidAPI-Host': "sky-scanner3.p.rapidapi.com"
#   }

#   response = requests.get(url, params=params, headers=headers)

#   # Check for successful response
#   if response.status_code == 200:
#     return jsonify(response.json())
#   else:
#     return f"Error: {response.status_code}", response.status_code

# if __name__ == "__main__":
#   app.run(debug=True)






# ##########
# this is priceline
from flask import Flask, jsonify, request
import requests

app = Flask(__name__)

API_KEY = "2eb4dd9632msh030756d81822a53p1bcb51jsn1200cff31b06"
RAPIDAPI_HOST = "priceline-com-provider.p.rapidapi.com"

@app.route("/flights/search", methods=['GET'])
def search_flights():
    url = "https://priceline-com-provider.p.rapidapi.com/v1/flights/search"

    headers = {
        'X-RapidAPI-Key': API_KEY,
        'X-RapidAPI-Host': RAPIDAPI_HOST
    }

    # Extract query parameters from request URL
    params = {
        'location_arrival': request.args.get('location_arrival'),
        'date_departure': request.args.get('date_departure'),
        'sort_order': request.args.get('sort_order'),
        'class_type': request.args.get('class_type'),
        'location_departure': request.args.get('location_departure'),
        'itinerary_type': request.args.get('itinerary_type'),
        'price_max': request.args.get('price_max'),
        'duration_max': request.args.get('duration_max'),
        'price_min': request.args.get('price_min'),
        'date_departure_return': request.args.get('date_departure_return'),
        'number_of_stops': request.args.get('number_of_stops'),
        'number_of_passengers': request.args.get('number_of_passengers')
    }

    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()  # Raise an exception for non-200 status codes
        return jsonify(response.json())
    except requests.exceptions.RequestException as e:
        print(f"An error occurred: {e}")
        return jsonify({'error': 'An error occurred during the API request'}), 500

if __name__ == "__main__":
    app.run(debug=True)


# http://localhost:5000/flights/search?location_arrival=NYC&date_departure=2024-03-28&sort_order=PRICE&class_type=ECO&location_departure=BOS&itinerary_type=ONE_WAY
# use this to check local host and test API 
