def get_wiki_airports():
# SR: this function is GPT-created from the tag-based task
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
        country = table.find_previous("h4").text.strip().replace('[edit]','')
        continent = table.find_previous("h3").text.strip().replace('[edit]','')
        # Find all the rows in the table
        rows = table.find_all("tr")
        # Loop through each row, skipping the first row (header)
        for row in rows[1:]:
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
                continue

    # Create a DataFrame from the lists
    df = pd.DataFrame({"Continent": continents, "Country": countries, "Location": locations, "IATA Code": iata_codes})

    return df

def get_wiki_airports_US():
# SR: this function is GPT-created from the tag-based task
    import requests
    from bs4 import BeautifulSoup
    import pandas as pd

    # Send a GET request to the Wikipedia page
    url = 'https://en.wikipedia.org/wiki/List_of_airports_in_the_United_States'
    response = requests.get(url)

    # Parse the HTML content using BeautifulSoup
    soup = BeautifulSoup(response.content, 'html.parser')

    # Find the table that contains the airports data
    table = soup.find('table', {'class': 'wikitable'})

    # Initialize lists to store data
    cities = []
    iata_codes = []
    states = []

    # Loop through the rows of the table and extract City, IATA, and State data
    for row in table.find_all('tr'):
        if row.has_attr('style') and 'background:#CCCCCC; font-weight:bold;' in row['style']:
            # Extract State from the first cell of the row
            state = row.find('td').text.strip()
        else:
            # Extract City and IATA from the respective cells
            cells = row.find_all('td')
            # SR: Some rows contain only one cell (which is empty), therefore this check is required
            if len(cells) > 1:
                city = cells[0].text.strip()
                iata = cells[2].text.strip()
                cities.append(city)
                iata_codes.append(iata)
                states.append(state)

    # Create a dataframe from the lists
    df = pd.DataFrame({'City': cities, 'IATA': iata_codes, 'State': states})

    return df