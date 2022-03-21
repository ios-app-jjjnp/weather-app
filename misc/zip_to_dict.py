# helper to generate swift zip to lat long dictionary from csv data

# for reference, calls should ultimately look like these:
# https://api.weather.gov/points/{latitude},{longitude}
# https://api.weather.gov/points/39.7456,-97.0892

# forecast data from above:
# https://api.weather.gov/gridpoints/{office}/{grid X},{grid Y}/forecast

import csv

CSV_FILENAME = "US.txt"

# initial code
print("struct LatLong {")
print("\tlet placeName: String")
print("\tlet stateName: String")
print("\tlet stateAbbrv: String")
print("\tlet lat: String")
print("\tlet long: String")
print("}\n")

zip_dict = "let zipDict: [String: LatLong] = ["

with open(CSV_FILENAME) as csv_file:
    zip_reader = csv.reader(csv_file, delimiter="\t")
    
    for line in zip_reader:
        zip_code = line[1]
        place_name = line[2]
        state_name = line[3]
        state_abbrv = line[4]
        lat = line[9]
        long = line[10]
        zip_dict += f""""{zip_code}": LatLong(placeName: "{place_name}", stateName: "{state_name}", stateAbbrv: "{state_abbrv}", lat: "{lat}", long: "{long}"), """

zip_dict += "]"

print(zip_dict)