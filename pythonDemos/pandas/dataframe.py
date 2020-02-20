import pandas as pd
import sqlite3



data = {
    'apples': [3, 2, 0, 1],
    'oranges': [0, 3, 7, 2]
}

fruits = pd.DataFrame(data)
print(fruits)

fruits = pd.DataFrame(data, index=['June', 'Septmeber', 'May', 'April'])
print(fruits)

print(fruits.loc['June'])

fruits.to_csv('fruits.csv')
fruits.to_excel('new_purchases.json')

con = sqlite3.connect("database.db")
fruits.to_sql('new_purchases', con)
