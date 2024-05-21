# import time
# import csv
# from selenium import webdriver
# from selenium.webdriver.chrome.options import Options
# from selenium.webdriver.common.by import By
# from selenium.webdriver.support.ui import WebDriverWait
# from selenium.webdriver.support import expected_conditions as EC
# from bs4 import BeautifulSoup

# def scrape_flights(driver):
#     # Wait for the flight rows to load
#     wait = WebDriverWait(driver, 20)
#     wait.until(EC.visibility_of_element_located((By.CLASS_NAME, "nrc6-inner")))

#     # Locate all flight rows using BeautifulSoup
#     soup = BeautifulSoup(driver.page_source, 'html.parser')
#     flight_rows = soup.find_all('div', class_='nrc6-inner')

#     flight_data = []
#     for row in flight_rows:
#         # Extract flight details
#         price = row.find("div", {"class": "M_JD-large-display"})
#         airline = row.find("div", {"class": "VY2U"})
#         duration = row.find("div", {"class": "vmXl vmXl-mod-variant-large"})
#         flightclass = row.find("div", {"class": "aC3z-name"})
#         flightstops = row.find("div", {"class": "c3J0r-container"})
#         city = row.find("div", {"class": "EFvI"})

#         # Clean and append data to flight_data list
#         flight_data.append({
#             "price": price.find("div", {"class": "f8F1-price-text"}).text.strip() if price else 'N/A',
#             "airline": airline.find("div", {"class": "c_cgF c_cgF-mod-variant-default"}).text.strip() if airline else 'N/A',
#             "duration": duration.text.strip() if duration else 'N/A',
#             "flightclass": flightclass.text.strip() if flightclass else 'N/A',
#             "flightstops": flightstops.find("div", {"class": "vmXl vmXl-mod-variant-default"}).text.strip() if flightstops else 'N/A',
#             "city": city.text.strip() if city else 'N/A'
#         })

#     return flight_data


# def main():
#     chrome_options = Options()
#     chrome_options.add_argument('--disable-gpu')
#     chrome_options.add_argument('--no-sandbox')
#     chrome_options.add_argument('--headless')  # Enable headless mode
#     chrome_options.add_argument('--disable-dev-shm-usage')  # Overcome limited resource problems
#     chrome_options.add_argument('--window-size=1920x1080')  # Set the window size for headless mode
#     chrome_options.add_argument('--start-maximized')
#     chrome_options.add_argument('--enable-features=NetworkService,NetworkServiceInProcess')
#     chrome_options.add_argument('--ignore-certificate-errors')
#     chrome_options.add_argument('--allow-insecure-localhost')
#     chrome_options.add_argument('--disable-blink-features=AutomationControlled')  # Disable automation control
#     chrome_options.add_argument('--incognito')  # Open in incognito mode

#     # Set a realistic user agent
#     chrome_options.add_argument('user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36')

#     driver = webdriver.Chrome(options=chrome_options)

#     url = "https://www.kayak.com/flights/PAR-NYC/2024-06-07/2024-06-14?sort=bestflight_a"
#     driver.get(url)
    
#     print("Page loaded")

#     time.sleep(10)

#     # Take a screenshot for debugging
#     driver.save_screenshot('screenshot_before_wait.png')
#     print("Screenshot before wait taken")

#     # Print page source for debugging
#     with open('page_source.html', 'w') as f:
#         f.write(driver.page_source)
#     print("Page source saved")

#     # Wait for the initial page load
#     try:
#         wait = WebDriverWait(driver, 20)
#         element = wait.until(EC.visibility_of_element_located((By.CLASS_NAME, "nrc6-inner")))
#         print("Initial element found:", element)
#     except Exception as e:
#         print("Initial load error:", e)
#         driver.quit()
#         return

#     flight_data = []
#     entries_to_scrape = 100
#     entry_counter = 0
#     retry_count = 0
#     max_retries = 5

#     while entry_counter < entries_to_scrape:
#         try:
#             # Scrape the current page
#             new_data = scrape_flights(driver)
#             flight_data.extend(new_data)
#             entry_counter = len(flight_data)
#             print(f"Scraped {len(new_data)} entries, total: {entry_counter}")

#             # Click the "Show more" button if available
#             try:
#                 show_more_button = WebDriverWait(driver, 10).until(
#                     EC.element_to_be_clickable((By.XPATH, "//div[@class='ULvh-button show-more-button']"))
#                 )
#                 show_more_button.click()
#                 time.sleep(2)  # Wait for the new results to load
#             except Exception as e:
#                 print("Show more button error:", e)
#                 break

#         except Exception as e:
#             print("Scraping error:", e)
#             retry_count += 1
#             if retry_count >= max_retries:
#                 print("Maximum retries reached. Exiting loop.")
#                 break
#             time.sleep(5)  # Wait before retrying
#             continue

#     # Write to CSV
#     with open('flight_prices.csv', mode='w', newline='') as file:
#         writer = csv.writer(file)
#         writer.writerow(['Price', 'Airline', 'Duration', 'Flight Class', 'Flight Stops', 'City'])
#         for flight in flight_data:
#             writer.writerow([flight['price'], flight['airline'], flight['duration'], flight['flightclass'], flight['flightstops'], flight['city']])

#     driver.quit()
#     print("CSV file created successfully.")

# if __name__ == "__main__":
#     main()



import time
import csv
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import StaleElementReferenceException
from bs4 import BeautifulSoup

def scrape_flights(driver):
    # Wait for the flight rows to load
    wait = WebDriverWait(driver, 30)  # Increase the wait time
    wait.until(EC.visibility_of_element_located((By.CLASS_NAME, "nrc6-inner")))

    # Locate all flight rows using BeautifulSoup
    soup = BeautifulSoup(driver.page_source, 'html.parser')
    flight_rows = soup.find_all('div', class_='nrc6-inner')

    flight_data = []
    for row in flight_rows:
        try:
            # Extract flight details
            price = row.find("div", {"class": "M_JD-large-display"})
            airline = row.find("div", {"class": "VY2U"})
            duration = row.find("div", {"class": "vmXl vmXl-mod-variant-large"})
            flightclass = row.find("div", {"class": "aC3z-name"})
            flightstops = row.find("div", {"class": "c3J0r-container"})
            city = row.find("div", {"class": "EFvI"})

            # Clean and append data to flight_data list
            flight_data.append({
                "price": price.find("div", {"class": "f8F1-price-text"}).text.strip() if price else 'N/A',
                "airline": airline.find("div", {"class": "c_cgF c_cgF-mod-variant-default"}).text.strip() if airline else 'N/A',
                "duration": duration.text.strip() if duration else 'N/A',
                "flightclass": flightclass.text.strip() if flightclass else 'N/A',
                "flightstops": flightstops.find("div", {"class": "vmXl vmXl-mod-variant-default"}).text.strip() if flightstops else 'N/A',
                "city": city.text.strip() if city else 'N/A'
            })
        except StaleElementReferenceException:
            pass  # Skip this element if it becomes stale

    return flight_data

def main():
    chrome_options = Options()
    chrome_options.add_argument('--headless')  # Run headless
    chrome_options.add_argument('--disable-gpu')
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--disable-dev-shm-usage')
    chrome_options.add_argument('--window-size=1920x1080')
    chrome_options.add_argument('--start-maximized')
    chrome_options.add_argument('--enable-features=NetworkService,NetworkServiceInProcess')
    chrome_options.add_argument('--ignore-certificate-errors')
    chrome_options.add_argument('--allow-insecure-localhost')
    chrome_options.add_argument('--disable-blink-features=AutomationControlled')
    chrome_options.add_argument('--incognito')
    chrome_options.add_argument('user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36')

    driver = webdriver.Chrome(options=chrome_options)

    url = "https://www.kayak.com/flights/DXB-KUL/2024-06-07/2024-06-14?sort=bestflight_a"
    driver.get(url)
    
    print("Page loaded")

    time.sleep(5)

    try:
        wait = WebDriverWait(driver, 20)
        element = wait.until(EC.visibility_of_element_located((By.CLASS_NAME, "nrc6-inner")))
        print("Initial element found:", element)
    except Exception as e:
        print("Initial load error:", e)
        driver.quit()
        return

    flight_data = []
    entries_to_scrape = 100
    entry_counter = 0
    retry_count = 0
    max_retries = 5

    while entry_counter < entries_to_scrape:
        try:
            # Scrape the current page
            new_data = scrape_flights(driver)
            flight_data.extend(new_data)
            entry_counter = len(flight_data)
            print(f"Scraped {len(new_data)} entries, total: {entry_counter}")

            # Click the "Show more" button if available
            try:
                show_more_button = WebDriverWait(driver, 20).until(
                    EC.element_to_be_clickable((By.XPATH, "//div[@class='ULvh-button show-more-button']"))
                )
                show_more_button.click()
                time.sleep(5)  # Increase wait time
            except Exception as e:
                print("Show more button error:", e)
                break

        except Exception as e:
            print("Scraping error:", e)
            retry_count += 1
            if retry_count >= max_retries:
                print("Maximum retries reached. Exiting loop.")
                break
            time.sleep(5)  # Wait before retrying
            continue

    # Write to CSV
    with open('flight_prices.csv', mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['Price', 'Airline', 'Duration', 'Flight Class', 'Flight Stops', 'City'])
        for flight in flight_data:
            writer.writerow([flight['price'], flight['airline'], flight['duration'], flight['flightclass'], flight['flightstops'], flight['city']])

    driver.quit()
    print("CSV file created successfully.")

if __name__ == "__main__":
    main()
