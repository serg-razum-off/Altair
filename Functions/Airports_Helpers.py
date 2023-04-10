def get_wiki_airports():
    # SR: ChatGPT written, SR designed 
    import requests
    from bs4 import BeautifulSoup
    import pandas as pd

    # Define the URL of the Wikipedia page
    url = "https://en.wikipedia.org/wiki/List_of_international_airports_by_country"

    # Send a GET request to the URL and get the response
    response = requests.get(url)

    # Parse the HTML content of the response using BeautifulSoup
    soup = BeautifulSoup(response.content, "html.parser")

    # Find all the tables on the page
    tables = soup.find_all("table", {"class": "wikitable"})

    # Initialize empty lists to store data
    continents = []
    countries = []
    locations = []
    iata_codes = []

    # Loop through each table
    for table in tables:
        # Find the country and continent information from the preceding h3 and h4 elements
        country = table.find_previous("h4").text.strip().replace("[edit]", "")
        continent = table.find_previous("h3").text.strip().replace("[edit]", "")
        # Find all the rows in the table
        rows = table.find_all("tr")
        # Loop through each row, SR: including header. If header -- try-catch will handle
        for row in rows:
            try:
                # Extract the Location and IATA Code from the columns of the row
                location = row.find_all("td")[0].text.strip()
                iata_code = row.find_all("td")[2].text.strip()
                # Append the continent, country, location, and IATA Code to the respective lists
                continents.append(continent)
                countries.append(country)
                locations.append(location)
                iata_codes.append(iata_code)
            except IndexError:
                # Skip rows that generate errors
                # SR: some rows are just headers
                continue

    # Create a DataFrame from the lists
    df = pd.DataFrame({"Continent": continents, "Country": countries, "Location": locations, "IATA Code": iata_codes})

    # Return the resulting DataFrame
    return df
