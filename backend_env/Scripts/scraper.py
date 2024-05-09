from selenium import webdriver
from bs4 import BeautifulSoup

# Set the path to the Chrome WebDriver executable
PATH = "backend_env/Scripts/chromedriver"

# Initialize Chrome WebDriver with ChromeOptions
options = webdriver.ChromeOptions()
options.add_argument("webdriver.chrome.driver=" + PATH)  # Specify Chrome WebDriver executable path

# Initialize Chrome WebDriver
driver = webdriver.Chrome(options=options)

# Navigate to the Kayak flights search page
driver.get("https://www.kayak.com/flights/DAC-KUL/2024-06-07/2024-06-14?sort=bestflight_a")

# Wait for the page to load
driver.implicitly_wait(10)  # Adjust the wait time as needed

# Get the page source
page_source = driver.page_source

# Parse the page source with BeautifulSoup
soup = BeautifulSoup(page_source, "html.parser")

# Find flight cards
flight_cards = soup.find_all("div", class_="Flights-Results-FlightResultItem")

# Extract flight information from each flight card
for card in flight_cards:
    # Extract airline
    airline = card.find("span", class_="sectionTransportCarrier").text.strip()
    
    # Extract price
    price = card.find("span", class_="price-text").text.strip()
    
    # Extract duration
    duration = card.find("div", class_="sectionFlightDuration").text.strip()
    
    # Print flight information
    print("Airline:", airline)
    print("Price:", price)
    print("Duration:", duration)
    print("-" * 50)

# Close the browser window
driver.quit()
