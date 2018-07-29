# bike-share
The shinyappio link for the project-> https://aungshumanz.shinyapps.io/bike-share.
The data for the project was obtained from Kaggle and can be found here https://www.kaggle.com/benhamner/sf-bay-area-bike-share.
There are four .csv files, of which I have used two: 'station.csv' and 'trip.csv'. To minimize the size of the data files, I  dropped unnecessary columns. The file 'cleaning.R' describes how I get the smaller datasets which are sent to the shinyappio server.

# Description of the app:
In the .csv files, we have information about a San Francisco based bike sharing program. 'station.csv' has information about the 70 bike stations scattered around the five cities (namely San Francisco, San Jose, Redwood city, Mountain view, and Palo Alto) in the bay area. In the 'stations' tab the app presents a map showing the location of the bike stations. There is also a bar plot showing number of bicycle docks in individual stations. The user can select one or more cities, and the stations located at those cities will be shown. The radius of a circle representing a station is proportional to the number of docks.

In the 'Trip frquency' tab, again the stations are shown, but this time the radius is proportional to trip frequency originating from a station. User may filter this by choosing city, hour of the day the trip originated, or a date range.  

In the 'station connection' tab user may select a station where a trip originates, and the left map will show all the stations where the trip ended. Larger circle again means larger frequency. On the right that trip frquency is shown in a bar plot.

'Trip duration' tab shows the trip duration in diffrent seasons (left) and seasonal variation of trip frequency. The right plot also shows the split between two different kinds of subscription. The programs has a system of monthly subscription where for a monthly fee, a subscriber can ride a bike to commute. By playing with the two sliderbars on this page, it can be seen that those subscribers more likely to ride the bikes for a shorter period of time, and during the peak morning and evening hours, possibly to commute to and from work. It is also clear that there is a marked dip in bike riding during the winter months despite of Bay area's comparatively mild winter.

The tab 'variation of trip frequency' shows variation of trip frequency over the two years. Unsurprisingly number of trips is larger on weekdays shown in red. There is steep decline in bike riding during the Christmas holidays. The right plot confirms the bimodal nature of bike ride during the weekdays. The two peaks correspond to morning and evening peak hours. The weekend rides don't show this behavior. 
