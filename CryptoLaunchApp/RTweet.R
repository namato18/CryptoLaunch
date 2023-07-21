library(rtweet)

AccessToken = "396987574-RbuhAtmyfAxoxa7ssugN4Ed5YK4KLYzosLkgyQfX"
AccessSecret = "fjBN0qEVHMrIHzsrSZlk8uroLP4Wh3AGolv7f3yWx8qNB"

Bearer = "AAAAAAAAAAAAAAAAAAAAAPI0owEAAAAAzA2XIMjdH3giPFt9WKQfsYQIZpo%3D7hFG8gSum6mJS2M0MaffwvJmaGjazRTDX8ySvBu9AJPRa56JAE"

APIKey = "JhIIXtuEd3j6F9ZjFiVH3iD93"
APISecret = "lBNfVtg1BzNlruc23FxhkBla3QOR8Gw6ajdoxObUTXf1vjcD9I"

auth = rtweet_bot(api_key = APIKey, api_secret = APISecret, access_token = AccessToken, access_secret = AccessSecret)

df <- search_tweets("#rstats", token = auth)

rtweet::search_users("ElusiveElephant", token = auth)
