from selenium import webdriver

# Set the path to the Chrome WebDriver executable
PATH = "backend_env/Scripts/chromedriver"

# Initialize Chrome WebDriver with ChromeOptions
options = webdriver.ChromeOptions()
options.add_argument("webdriver.chrome.driver=" + PATH)  # Specify Chrome WebDriver executable path

# Initialize Chrome WebDriver
driver = webdriver.Chrome(options=options)

# Navigate to a webpage
driver.get("https://www.google.com")

# Get the title of the webpage
print("Title of the webpage:", driver.title)

# Close the browser window
driver.quit()
