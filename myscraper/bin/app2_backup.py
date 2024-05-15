import time
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.firefox.options import Options
from bs4 import BeautifulSoup
import csv

try:

    chrome_options = Options()
    # chrome_options.add_argument("--disable-javascript")

    # Instantiate the WebDriver object with the modified options
    # driver = webdriver.Chrome(options=chrome_options)
    driver = webdriver.Firefox()
    
    to_location = 'LCA'
    url = "https://www.kayak.com/flights/SYD-LIS/2024-06-07/2024-06-14?sort=bestflight_a"

    driver.get(url)
    # No need for sleep(5) as JavaScript is disabled

    # Locate flight rows using BeautifulSoup instead of WebDriver
    soup = BeautifulSoup(driver.page_source, 'html.parser')

    list_prices = []
    list_airlines = []
    list_duration = []
    list_flightclass = []
    list_flightstops = []
    list_city = []

    entry_counter = 0

    while entry_counter < 50:
        flight_rows = soup.find_all('div', class_='nrc6-inner')

        for row in flight_rows:
            # Extract price using BeautifulSoup
            temp_price = row.find("div", {"class": "M_JD-large-display"})
            price = temp_price.find("div", {"class": "f8F1-price-text"}).text.strip() if temp_price else 'NA'

            temp_airlines = row.find("div", {"class": "VY2U"})
            airlines = temp_airlines.find("div", {"class": "c_cgF c_cgF-mod-variant-default"}).text.strip() if temp_airlines else 'NA'

            temp_duration = row.find("div", {"class": "vmXl vmXl-mod-variant-large"})
            duration = temp_duration.text.strip() if temp_duration else 'NA'

            flightclass = row.find("div", {"class": "aC3z-name"}).text.strip()

            # Extract flight stops information
            temp_flightstops = row.find("div", {"class": "c3J0r-container"})
            flightstops = temp_flightstops.find("div", {"class": "vmXl vmXl-mod-variant-default"}).text.strip() if temp_flightstops else 'NA'

            # Extract city information
            temp_city = row.find("div", {"class": "c3J0r-container"})
            city = temp_city.find("div", {"class": "EFvI"}).text.strip() if temp_city else 'NA'
            
            list_prices.append(price)
            list_airlines.append(airlines)
            list_duration.append(duration)
            list_flightclass.append(flightclass)
            list_flightstops.append(flightstops)
            list_city.append(city)

            entry_counter += 1
            if entry_counter == 50:
                break

        # Check if there's a "Show more" button
        show_more_button = driver.find_element("xpath", "//div[@class='ULvh-button show-more-button']")
        if not show_more_button.is_displayed():
            time.sleep(3)

        # Click the "Show more" button and wait for results to load
        show_more_button.click()
        time.sleep(2)  # Wait for the new results to load
        soup = BeautifulSoup(driver.page_source, 'html.parser')

    # Writing to CSV
    with open('flight_prices.csv', mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['Price', 'Airline', 'Duration', 'Flight Class', 'Flight Stops', 'City'])  # Define the header row
        for i in range(len(list_prices)):
            writer.writerow([list_prices[i], list_airlines[i], list_duration[i], list_flightclass[i], list_flightstops[i], list_city[i]])  # Write each price, airline, duration, flight class, and flight stops in separate columns
            
    driver.quit()

    print("CSV file created successfully.")
except Exception as e:
    print("An error occurred:", e)
