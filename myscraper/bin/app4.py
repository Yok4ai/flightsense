from flask import Flask, request, jsonify
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException, NoSuchElementException, ElementClickInterceptedException, ElementNotInteractableException
from bs4 import BeautifulSoup
import time

app = Flask(__name__)

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

            # Check if there's a "Show more" button
            entries_to_scrape = 100
            entry_counter = len(flight_data)
            retry_count = 0
            max_retries = 5

            while entry_counter < entries_to_scrape:
                try:
                    show_more_button = WebDriverWait(driver, 10).until(
                        EC.element_to_be_clickable((By.XPATH, "//div[@class='ULvh-button show-more-button']"))
                    )
                    try:
                        show_more_button.click()
                    except ElementClickInterceptedException:
                        driver.execute_script("arguments[0].click();", show_more_button)
                    time.sleep(2)  # Wait for the new results to load

                    flight_data.extend(scrape_flights(driver))
                    entry_counter = len(flight_data)
                except (NoSuchElementException, ElementNotInteractableException) as e:
                    print(f"Error: {e}")
                    retry_count += 1
                    if retry_count >= max_retries:
                        print("Maximum retries reached. Exiting loop.")
                        break
                    time.sleep(5)  # Wait before retrying
                    continue  # Retry the loop

        finally:
            # Close WebDriver
            driver.quit()

        return jsonify({"flights": flight_data})

    except TimeoutException:
        return jsonify({"error": "Timeout occurred while waiting for page to load."})
    except Exception as e:
        return jsonify({"error": str(e)})

if __name__ == '__main__':
    app.run(debug=True)
