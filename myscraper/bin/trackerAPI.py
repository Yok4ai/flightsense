from flask import Flask, request, jsonify
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException, NoSuchElementException, ElementClickInterceptedException, ElementNotInteractableException
from bs4 import BeautifulSoup
import time
from apscheduler.schedulers.background import BackgroundScheduler
from flask_socketio import SocketIO, emit

app = Flask(__name__)
socketio = SocketIO(app)

alerts = {}

def scrape_flights(driver):
    # Wait for page to load (adjust wait time as needed)
    wait = WebDriverWait(driver, 20)
    wait.until(EC.visibility_of_element_located((By.CLASS_NAME, "nrc6-inner")))

    # Locate all flight rows using BeautifulSoup
    soup = BeautifulSoup(driver.page_source, 'html.parser')
    flight_rows = soup.find_all('div', class_='nrc6-inner')  # Adjust class name if necessary

    # Process flight data
    flight_data = []
    for row in flight_rows:
        # Extract flight details
        price = row.find("div", {"class": "M_JD-large-display"})
        airline = row.find("div", {"class": "VY2U"})
        duration = row.find("div", {"class": "vmXl vmXl-mod-variant-large"})
        flightclass = row.find("div", {"class": "aC3z-name"})
        flightstops = row.find("div", {"class": "c3J0r-container"})

        # Extract city information
        city = row.find("div", {"class": "c3J0r-container"})
        city = city.find("div", {"class": "EFvI"}) if city else None

        if all((price, airline, duration, flightclass, flightstops, city)):
            flight_data.append({
                "price": price.find("div", {"class": "f8F1-price-text"}).text.strip() if price else 'N/A',
                "airline": airline.find("div", {"class": "c_cgF c_cgF-mod-variant-default"}).text.strip() if airline else 'N/A',
                "duration": duration.text.strip() if duration else 'N/A',
                "flightclass": flightclass.text.strip() if flightclass else 'N/A',
                "flightstops": flightstops.find("div", {"class": "vmXl vmXl-mod-variant-default"}).text.strip() if flightstops else 'N/A',
                "city": city.text.strip() if city else 'N/A'
            })

    return flight_data

def check_price_alerts():
    for alert_id, alert in alerts.items():
        chrome_options = Options()
        chrome_options.add_argument('--disable-gpu')
        chrome_options.add_argument('--no-sandbox')
        driver = webdriver.Chrome(options=chrome_options)

        try:
            url = f"https://www.kayak.com/flights/{alert['departure_city']}-{alert['destination_city']}/{alert['departure_date']}/{alert['return_date']}?sort=bestflight_a"
            driver.get(url)
            flight_data = scrape_flights(driver)

            for flight in flight_data:
                price = float(flight['price'].replace('$', '').replace(',', ''))
                if price <= alert['target_price']:
                    # Send WebSocket notification
                    socketio.emit('price_alert', {
                        'alert_id': alert_id,
                        'flight': flight,
                        'device_id': alert['device_id']
                    }, room=alert['device_id'])
                    print(f"Alert {alert_id}: Found a flight at ${price}")
                    break

        finally:
            driver.quit()

# Configure the scheduler
scheduler = BackgroundScheduler()
scheduler.add_job(func=check_price_alerts, trigger="interval", minutes=5)  # Run every 5 minutes
scheduler.start()

@app.route('/search-flights', methods=['POST'])
def search_flights():
    try:
        # Get request data
        data = request.json
        departure_city = data['departure_city']
        destination_city = data['destination_city']
        departure_date = data['departure_date']
        return_date = data['return_date']
        flight_class = data['flight_class']

        # Set Chrome options for headless mode
        chrome_options = Options()
        chrome_options.add_argument('--disable-gpu')
        chrome_options.add_argument('--no-sandbox')
        # Remove headless argument to run browser in non-headless mode
        # chrome_options.add_argument('--headless')

        # Instantiate the WebDriver object with Chrome options
        driver = webdriver.Chrome(options=chrome_options)

        try:
            # Construct URL
            url = f"https://www.kayak.com/flights/{departure_city}-{destination_city}/{departure_date}/{return_date}?sort=bestflight_a"
            driver.get(url)

            # Scrape initial flights
            flight_data = scrape_flights(driver)

        finally:
            # Close WebDriver
            driver.quit()

        return jsonify({"flights": flight_data})

    except TimeoutException:
        return jsonify({"error": "Timeout occurred while waiting for page to load."})
    except Exception as e:
        return jsonify({"error": str(e)})

@app.route('/set-alert', methods=['POST'])
def set_alert():
    data = request.json
    alert_id = len(alerts) + 1
    alerts[alert_id] = {
        'departure_city': data['departure_city'],
        'destination_city': data['destination_city'],
        'departure_date': data['departure_date'],
        'return_date': data['return_date'],
        'flight_class': data['flight_class'],
        'target_price': data['target_price'],
        'device_id': data['device_id']  # Assume we notify users via WebSocket
    }
    return jsonify({"message": "Alert set successfully!", "alert_id": alert_id})

if __name__ == '__main__':
    try:
        socketio.run(app, debug=True)
    except (KeyboardInterrupt, SystemExit):
        scheduler.shutdown()
