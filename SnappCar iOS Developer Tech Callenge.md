# 
# SnappCar Interview
Challenge: Build an iOS client using Swift that allows the user to search for cars in a city in any of these three countries:

* Netherlands (`NL`)
* Germany (`DE`)
* Sweden (`SE`)

Additionally the user can select the maximum distance and he/she/they can change the sorting order and page through the search results.

The results should be refreshed automatically when a parameter is changed. For more details on how the Search API works look [here](#search-api)

## Features

The app should support the following features (but it's okay if you can't finish everything!)

1. [City Search](#city-search)
2. [Filters](#filters)
3. [Pagination](#pagination)

### City Search

You can **hardcode** the countries and cities as well as their latitude / longitude you want a user to search in.

The user should see an input field where he/she/they can enter a city name. The results should be displayed below in a list.  500ms after the user stopped typing, it should search for the city. If the user continues typing afterwards, the previous search should be canceled and a new one should be done after the typing stops for another 500ms. So on and so forth…

>**Note:**  The box will search as the user is typing with a **delay of 500ms** after the user stopped typing.

### Filters

The Search API supports the following filters to narrow down your search results:

#### Distance Change

There should be a dropdown on the page which allows the user to change the maximum distance (values in **meters**). The possible options are:

 * `3000`
 * `5000`
 * `7000`

#### Sorting Change

There should be a dropdown on the page which allows the user to change the sorting order. The possible options are:

* `price`
* `recommended`
* `distance`

### Pagination

As the user scrolls to the end of the first page new search results should be loaded in batches of `10`. The query parameter to pass to the API is `limit` and `offset`. The `offset` is determined by adding the page sizes starting with `0`. See an example on how to use it below.


## Search API

### Query Params

The following parameters are available:

| **Parameter** | **Type** |        **Notes and options** |
|---------------|----------|-----------------------------:|
| limit         | Integer  |                         1-10 |
| offset        | Integer  |                            0 |
| country       | String   |    2 letter ISO Country code |
| lat           | Float    |            52.09073739999999 |
| lng           | Float    |                    5.1214201 |
| max-distance  | Integer  |              Range in meters |
| sort          | String   | recommended, price, distance |
| order         | String   |                    asc, desc |

Searching for cars is done by doing an `HTTP GET` request to:
https://api.snappcar.nl/v2/search/query?sort=price&country=NL&lat=52.09073739999999&lng=5.1214201&max-distance=3000&limit=10&offset=0


### Bonus Points

We always love to see tests and proper error handling but it's okay if you omit this here.

### Final notes

If you use any third party dependencies please briefly state in your Readme why you opted for it (i.e. ReactiveSwift). 

If you encounter weird **403s** from the API, please let us know, so you don’t waste any time wrestling with that.

Please don’t spend more than **4 hours** on this. If it’s not finished, it’s ok. This will provide talking points for the next technical discussion.
You can use https://github.com/.

## Good luck! 🍀 
