from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

@app.route('/get_flight_info', methods=['GET'])
def get_flight_info():
    url = "https://priceline-com-provider.p.rapidapi.com/v1/flights/search"
    
    # Extract parameters from request
    location_arrival = request.args.get('location_arrival')
    date_departure = request.args.get('date_departure')
    sort_order = request.args.get('sort_order')
    class_type = request.args.get('class_type')
    location_departure = request.args.get('location_departure')
    itinerary_type = request.args.get('itinerary_type')
    price_max = request.args.get('price_max')
    duration_max = request.args.get('duration_max')
    price_min = request.args.get('price_min')
    date_departure_return = request.args.get('date_departure_return')
    number_of_stops = request.args.get('number_of_stops')
    number_of_passengers = request.args.get('number_of_passengers')
    
    # Set up querystring
    querystring = {
        "location_arrival": location_arrival,
        "date_departure": date_departure,
        "sort_order": sort_order,
        "class_type": class_type,
        "location_departure": location_departure,
        "itinerary_type": itinerary_type,
        "price_max": price_max,
        "duration_max": duration_max,
        "price_min": price_min,
        "date_departure_return": date_departure_return,
        "number_of_stops": number_of_stops,
        "number_of_passengers": number_of_passengers
    }

    headers = {
        "X-RapidAPI-Key": "2eb4dd9632msh030756d81822a53p1bcb51jsn1200cff31b06",
        "X-RapidAPI-Host": "priceline-com-provider.p.rapidapi.com"
    }

    response = requests.get(url, headers=headers, params=querystring)

    return jsonify(response.json())

if __name__ == '__main__':
    app.run(debug=True)
