# bike-share
The shinyappio link for the project-> https://aungshumanz.shinyapps.io/bike-share.
The data for the project was obtained from Kaggle and can be found here https://www.kaggle.com/benhamner/sf-bay-area-bike-share.
There are four .csv files, of which I have used two: 'station.csv' and 'trip.csv'. To minimize the size of the data files, I  dropped unnecessary columns. The file 'cleaning.R' describes how I get the smaller datasets which are sent to the shinyappio server.

# Description of the app:
In the .csv files, we have information about a San Francisco based bike sharing program. 'station.csv' has information anout the 70 bike stations scattered around the five cities (namely San Francisco, San Jose, Redwood city, Mountain view, and Palo Alto) in the bay area. In the 'stations' tab the app presents a map showing the location of the bike stations. There is also a bar plot showing number of bicycle docks in individual stations. The user can select one or more cities, and the stations located at those cities will be shown. The radius of a circle representing a station is proportional to the number of docks.

In the 'Trip frquency' tab, again the stations are shown, but this time the radius is proportional to trip frequency originating from a station. User may filter this by choosing city, hour of the day the trip originated, or a date range.  

In the 'station connection' tab user may select a station where a trip originates, and the left map will show all the stations where the trip ended. Larger circle again means larger frequency. On the right that trip frquency is shown in a bar plot.

