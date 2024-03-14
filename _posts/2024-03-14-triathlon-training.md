---
layout: post
title: "Scraping Together a Triathlon Training Plan"
tags: python web-scraping beautifulsoup
categories: 
  - Web Scraping
---

I signed up to compete in a half-Ironman(tm) triathlon on September 8, 2024. Completing a half-Ironman(tm) involves:
- 1.2 mile swim
- 56 mile bike
- 13.1 mile run

It's nice to have a solid training plan to prepare for such a demanding event, and many kind folks have compiled and published these online for public reference. Rather than constantly referring to a cluttered website, though, I wanted to put all of the recommended workouts on my calendar. I like my calendar.

By the power of python, beautifulsoup, and pandas, I've done just that - scraped my selected training plan from the web and re-arranged the information into a format which can be imported into Google Calendar, as I prefer.

# How do?

Retrieve and parse the HTML, referring to my browser's `Inspect` utility to analyse relevant page structure.

```python
import requests
import bs4
import pandas as pd

URL = 'https://www.triathlete.com/training/super-simple-ironman-70-3-triathlon-training-plan/'
RACE_DAY = '9/8/2024'
OUT_FILE = '~/Desktop/sc.csv'

response = requests.get(URL)
soup = bs4.BeautifulSoup(response.text)
tables = soup.find_all('table')
len(tables)
```

    17

Prep data frame and append a new row for each day in each week-table (all tables except the first table).

```python
df = pd.DataFrame({'dow': [], 'wo1': [], 'wo2': [], 'wo3': []})

for i, t in enumerate(tables):
    if i == 0: continue
    # print(f'Week {i}')
    
    trs = t.find_all('tr')
    for tr in trs:
        tds = tr.find_all('td')
        # print(' | '.join(td.text for td in tds))
        df.loc[df.shape[0]] = [td.text for td in tds] + ([''] if i < 16 else [])
        
df.head()
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>dow</th>
      <th>wo1</th>
      <th>wo2</th>
      <th>wo3</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Monday</td>
      <td>Rest</td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <th>1</th>
      <td>Tuesday</td>
      <td>Bike 40 minutes moderate with 4 x 30-second sp...</td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <th>2</th>
      <td>Wednesday</td>
      <td>Swim 800 yards total. Main set: 8 x 25 yards, ...</td>
      <td>Run 4 miles moderate + 2 x 10-second hill spri...</td>
      <td></td>
    </tr>
    <tr>
      <th>3</th>
      <td>Thursday</td>
      <td>Bike 40 minutes moderate.</td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <th>4</th>
      <td>Friday</td>
      <td>Swim 800 yards total. Main set: 3 x 100 yards ...</td>
      <td>Run 4 miles moderate.</td>
      <td></td>
    </tr>
  </tbody>
</table>
</div>


Given the race day as the end date, back-fill to assign dates until training day 1.

```python
df['start date'] = pd.date_range(end=RACE_DAY, periods=df.shape[0])
df.head()
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>dow</th>
      <th>wo1</th>
      <th>wo2</th>
      <th>wo3</th>
      <th>start date</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Monday</td>
      <td>Rest</td>
      <td></td>
      <td></td>
      <td>2024-05-20</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Tuesday</td>
      <td>Bike 40 minutes moderate with 4 x 30-second sp...</td>
      <td></td>
      <td></td>
      <td>2024-05-21</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Wednesday</td>
      <td>Swim 800 yards total. Main set: 8 x 25 yards, ...</td>
      <td>Run 4 miles moderate + 2 x 10-second hill spri...</td>
      <td></td>
      <td>2024-05-22</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Thursday</td>
      <td>Bike 40 minutes moderate.</td>
      <td></td>
      <td></td>
      <td>2024-05-23</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Friday</td>
      <td>Swim 800 yards total. Main set: 3 x 100 yards ...</td>
      <td>Run 4 miles moderate.</td>
      <td></td>
      <td>2024-05-24</td>
    </tr>
  </tbody>
</table>
</div>

I want each workout to have its own event, e.g. multiple workouts in one day should result in multiple events that day.

So, melt the multiple `wo` workout columns into just one, in a long format with repeated dates. Then, drop rows with empty descriptions, so days where there are fewer workouts don't have extra empty events.

```python
pivot = df.melt(
    id_vars='start date', 
    value_name='description', 
    value_vars=['wo1', 'wo2', 'wo3']
)
pivot_reduced = pivot.drop('variable', axis=1).drop(pivot[pivot['description'] == ''].index)
pivot_reduced.head()
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>start date</th>
      <th>description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2024-05-20</td>
      <td>Rest</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2024-05-21</td>
      <td>Bike 40 minutes moderate with 4 x 30-second sp...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2024-05-22</td>
      <td>Swim 800 yards total. Main set: 8 x 25 yards, ...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2024-05-23</td>
      <td>Bike 40 minutes moderate.</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2024-05-24</td>
      <td>Swim 800 yards total. Main set: 3 x 100 yards ...</td>
    </tr>
  </tbody>
</table>
</div>


Use the first word of each workout description as its event subject/title, and re-sort by date for visual review.

```python
pivot_reduced['subject'] = [x[0].upper() for x in pivot_reduced['description'].str.split()]
pivot_reduced.sort_values('start date')
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>start date</th>
      <th>description</th>
      <th>subject</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2024-05-20</td>
      <td>Rest</td>
      <td>REST</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2024-05-21</td>
      <td>Bike 40 minutes moderate with 4 x 30-second sp...</td>
      <td>BIKE</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2024-05-22</td>
      <td>Swim 800 yards total. Main set: 8 x 25 yards, ...</td>
      <td>SWIM</td>
    </tr>
    <tr>
      <th>114</th>
      <td>2024-05-22</td>
      <td>Run 4 miles moderate + 2 x 10-second hill spri...</td>
      <td>RUN</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2024-05-23</td>
      <td>Bike 40 minutes moderate.</td>
      <td>BIKE</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>221</th>
      <td>2024-09-06</td>
      <td>Run 3 miles easy.</td>
      <td>RUN</td>
    </tr>
    <tr>
      <th>110</th>
      <td>2024-09-07</td>
      <td>Swim 10 minutes easy with 4 x 30 seconds at ra...</td>
      <td>SWIM</td>
    </tr>
    <tr>
      <th>222</th>
      <td>2024-09-07</td>
      <td>Bike 10 minutes with 4 x 30 seconds fast.</td>
      <td>BIKE</td>
    </tr>
    <tr>
      <th>334</th>
      <td>2024-09-07</td>
      <td>Run 10 minutes with 4 x 20 seconds at 90 perce...</td>
      <td>RUN</td>
    </tr>
    <tr>
      <th>111</th>
      <td>2024-09-08</td>
      <td>RACE DAY</td>
      <td>RACE</td>
    </tr>
  </tbody>
</table>
<p>161 rows × 3 columns</p>
</div>


Write dataframe to CSV for calendar import.

```python
pivot_reduced.sort_values('start date').to_csv(OUT_FILE, index=False)
```

Huzzah
