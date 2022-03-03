# LivSecurityShoppingList
Liv Security Assignment

This README is created so i am able to explain my thinking and implementation of my code.

I wanted to connect to a database for the shopping list so i looked at using iCloud Kit to store and read my data from. i did some reasearch and set up my database
for the Shopping list.

Here is a link to the documentation for more clarity on what i used: https://developer.apple.com/documentation/cloudkit

I created an file called CloudKitEnums, here i stored the enums of the strings i was using across the different functions in the ViewController.

In the ViewController i created my tableview and registered a cell with my cell identifier. I then proceeded to add the tableview datasoruce, cellForRowAt 
and numberOfRowsInSection functions. In those functions i was setting the text being returned from the database and the number of rows to display.

I then created the saveItem() and the fetchItems() functions which save the entry in the database and fetch all the data stored in the database. I then created 
a similar function that is used when the user pulls to refresh the table. This function will also fetch the data stored in the database.

I created a NavigationController and added a rightBarButtonItem to the navigation item, this button is for the user to add an entry into the Shopping list.

The one part of functionality i was not able to get right was the delete functionlity, i have included it in the project as you can see my working and thought process
but i was not successful in deleting it from the database. 

I've included in the README a short recording demo of the app to show the displaying of data from the database, as well as adding a record to the database and 
the functionality of deleting.

https://user-images.githubusercontent.com/21314284/156596896-4a88a165-41ca-4751-93a2-b2a1a15e564a.mp4

Screenshot if the iCloud Database: 
<img width="1417" alt="Screenshot 2022-03-03 at 17 38 48" src="https://user-images.githubusercontent.com/21314284/156598400-7529ba2d-a307-4840-a5f3-5f6cb139a5be.png">


