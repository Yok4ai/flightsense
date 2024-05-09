from flask import Flask, request, jsonify
import time
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from bs4 import BeautifulSoup

app = Flask(__name__)

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

        # Configure Chrome options to disable JavaScript
        chrome_options = Options()
        chrome_options.add_argument("--disable-javascript")

        # Instantiate the WebDriver object with the modified options
        driver = webdriver.Chrome(options=chrome_options)

        # Construct URL
        url = f"https://www.kayak.com/flights/{departure_city}-{destination_city}/{departure_date}/{return_date}?sort=bestflight_a"

        driver.get(url)

        # Locate flight rows using BeautifulSoup instead of WebDriver
        soup = BeautifulSoup(driver.page_source, 'html.parser')

        # Process flight data
        flight_data = []
        entry_counter = 0
        while entry_counter < 100:
            flight_rows = soup.find_all('div', class_='nrc6-inner')

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
                        "price": price.find("div", {"class": "f8F1-price-text"}).text.strip(),
                        "airline": airline.find("div", {"class": "c_cgF c_cgF-mod-variant-default"}).text.strip(),
                        "duration": duration.text.strip(),
                        "flightclass": flightclass.text.strip(),
                        "flightstops": flightstops.find("div", {"class": "vmXl vmXl-mod-variant-default"}).text.strip(),
                        "city": city.text.strip()
                    })

                    entry_counter += 1
                    if entry_counter == 100:
                        break

            # Check if there's a "Show more" button
            show_more_button = driver.find_element("xpath", "//div[@class='ULvh-button show-more-button']")
            if not show_more_button.is_displayed():
                break

            # Click the "Show more" button and wait for results to load
            show_more_button.click()
            time.sleep(2)  # Wait for the new results to load
            soup = BeautifulSoup(driver.page_source, 'html.parser')

        driver.quit()

        return jsonify({"flights": flight_data})

    except Exception as e:
        return jsonify({"error": str(e)})

if __name__ == '__main__':
    app.run(debug=True)
