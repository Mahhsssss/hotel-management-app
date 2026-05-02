# hotel_de_luna

A dynamic hotel management application for a hotel group using flutter and firebase as a part of a college group project!

## Introduction

The Hotel Management Application is a mobile booking application that was created with the
use of Flutter. The application was created for a made-up chain of high-end resort hotels, Hotel De Luna.
The app was created with the primary objective of customers making sure they book directly
instead of confirming their bookings through third-party websites. By promoting direct bookings,
the application helps the hotel offer better pricing, customer data and overall service quality.
This also helps build customer loyalty and provides convenience for them. The application has
two parts: User login as well as Employee login.

The system allows an employee to:
● Log in to their personal employee accounts.
● View assigned tasks and track their progress.
● The list view lets the employee verify the tasks they have completed.
● Employees have different permissions:none,some,all
● Employees that have all permissions can manage the other employees and view all their
tasks.

The system allows the customer to:
● Sign up and create an account within the Hotel De Luna application.
● Take a look at all the locations of hotels and select their preferred destination.
● Use the filtering options that allows a user to find a hotel based on their price range,
ratings, the check-in/check-out dates and desired amenities they want.
● Book a room.
● Process payments and confirm the booking.


## DATABASE SCHEMA (DATA DICTIONARY)

Bookings- to store customer bookings [CustomerID, RoomID, HotelID, Booked by
(EmployeeID)]
Customers- to store customer information [Name, Email, UserID]
Employees- to store employee records [Name, Permissions, Role, Salary, EmployeeID]
Hotels- storing hotel information [Name, Location, Ratings, Price, Amenities, RoomType,
Images, Description]
Payments- storing payment transactions [Amount, BookingID]
Tasks- storing employee tasks [Task name, EmployeeID, Completed, Description]

