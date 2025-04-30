CREATE SCHEMA IF NOT EXISTS	airline;

CREATE TABLE IF NOT EXISTS airline.booking_agents  (
    Agent_id INT NOT NULL,
    Agent_name VARCHAR NOT NULL,
    Agent_details VARCHAR NOT NULL,
	PRIMARY KEY (Agent_id)
);

CREATE TABLE IF NOT EXISTS airline.payments (
    Payment_id INT NOT NULL,
    Payment_status_code INT NOT NULL,
    Payment_date DATE NOT NULL,
    Payment_amount INT NOT NULL,
    PRIMARY KEY (Payment_id)
);


CREATE TABLE IF NOT EXISTS airline.reservation_payments (
    Reservation_id INT NOT NULL,
    Payment_id INT NOT NULL,
	PRIMARY KEY (Reservation_id),
    FOREIGN KEY (Payment_id) REFERENCES airline.payments(Payment_id)
	ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS airline.passengers (
    Passenger_id INT NOT NULL,
    First_name VARCHAR NOT NULL,
	Second_name VARCHAR NOT NULL,
	Last_name VARCHAR NOT NULL,
    Phone_number INT NOT NULL,
	Email_address VARCHAR NOT NULL,
	Address_lines VARCHAR NOT NULL,
	City VARCHAR NOT NULL,
	State_province_county VARCHAR NOT NULL,
	Country VARCHAR(3) NOT NULL,
	Other_passenger_details VARCHAR,
    PRIMARY KEY  (Passenger_id)
);

CREATE TABLE IF NOT EXISTS airline.flight_schedules (
    Flight_number VARCHAR NOT NULL,
    Airline_code VARCHAR NOT NULL,
	Usual_aircraft_type_code VARCHAR NOT NULL,
    Origin_airport_code VARCHAR NOT NULL,
	Destination_airport_code VARCHAR NOT NULL,
    Departure_date_time TIMESTAMP NOT NULL,
	Arrival_date_time TIMESTAMP NOT NULL,
    PRIMARY KEY (Flight_number, Airline_code, Usual_aircraft_type_code, Origin_airport_code, Destination_airport_code, Departure_date_time)
);

ALTER TABLE airline.flight_schedules
ADD CONSTRAINT Flight_number UNIQUE (Flight_number);

CREATE TABLE IF NOT EXISTS airline.itenerary_legs (
	Leg_id INT NOT NULL,
	Reservation_id INT NOT NULL,
	PRIMARY KEY (Leg_id),
	FOREIGN KEY (Reservation_id) REFERENCES airline.reservation_payments(Reservation_id)
	ON UPDATE CASCADE ON DELETE CASCADE
);

ALTER TABLE airline.flight_schedules
ADD CONSTRAINT unique_usual_aircraft_type UNIQUE (Usual_aircraft_type_code);

ALTER TABLE airline.flight_schedules
ADD CONSTRAINT origin_airport_code UNIQUE (Origin_airport_code);

ALTER TABLE airline.flight_schedules
ADD CONSTRAINT Destination_airport_code UNIQUE (Destination_airport_code);

CREATE TABLE IF NOT EXISTS airline.legs (
	Leg_id INT NOT NULL,
	Flight_number VARCHAR NOT NULL,
	Airline_code VARCHAR NOT NULL,
	Usual_aircraft_type_code VARCHAR NOT NULL,
	Origin_airport_code VARCHAR NOT NULL,
	Destination_airport_code VARCHAR NOT NULL,
	Departure_date_time TIMESTAMP NOT NULL,
	Arrival_date_time TIMESTAMP NOT NULL,
	Actual_departure_time TIMESTAMP NOT NULL,
	Actual_arrival_time TIMESTAMP NOT NULL,
	Departure_efficiency BOOL,
	FOREIGN KEY (leg_id) REFERENCES airline.itenerary_legs(Leg_id),
	FOREIGN KEY (Flight_number, Airline_code, Usual_aircraft_type_code, Origin_airport_code, Destination_airport_code, Departure_date_time)
    REFERENCES airline.flight_schedules(Flight_number, Airline_code, Usual_aircraft_type_code, Origin_airport_code, Destination_airport_code, Departure_date_time)
	ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS airline.itenerary_legs (
    Leg_id INT NOT NULL,
    Reservation_id VARCHAR NOT NULL,
    PRIMARY KEY (Leg_id),
	FOREIGN KEY (Reservation_id) REFERENCES airline.itenerary_reservations(Reservation_id)
	ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS airline.itenerary_reservations(
    Reservation_id INT NOT NULL,
    Agent_id INT NOT NULL,
    Passenger_id INT NOT NULL,
	Reservation_status_code VARCHAR NOT NULL,
	Usual_aircraft_type_code VARCHAR NOT NULL,
	Origin_airport_code VARCHAR NOT NULL,
	Destination_airport_code VARCHAR NOT NULL,
	Ticket_type_code VARCHAR NOT NULL,
	Travel_class_code VARCHAR NOT NULL,
	Datre_reservation_made DATE NOT NULL,
	Number_in_party INT NOT NULL,
    PRIMARY KEY (Reservation_id),
    FOREIGN KEY (Agent_id) REFERENCES airline.booking_agents(Agent_id),
	FOREIGN KEY (Passenger_id) REFERENCES airline.passengers(Passenger_id),
	FOREIGN KEY (Usual_aircraft_type_code) REFERENCES airline.flight_schedules(Usual_aircraft_type_code),
	FOREIGN KEY (Origin_airport_code) REFERENCES airline.flight_schedules(Origin_airport_code),
	FOREIGN KEY (Destination_airport_code) REFERENCES airline.flight_schedules(Destination_airport_code)
	ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS airline.airports (
   	Airport_code VARCHAR(3) NOT NULL,
	Airport_name VARCHAR NOT NULL,
	Airport_location VARCHAR NOT NULL,
	Other_details VARCHAR,
    PRIMARY KEY (Airport_code)
);

CREATE TABLE IF NOT EXISTS airline.ref_calendar (
   	Day_date INT NOT NULL,
	Day_number INT NOT NULL,
	Business_day_yn INT NOT NULL,
    PRIMARY KEY (Day_date)
);

CREATE TABLE IF NOT EXISTS airline.flight_costs (
	Flight_number VARCHAR NOT NULL,
	Aircraft_type_code VARCHAR NOT NULL,
	Valid_from_date DATE NOT NULL,
	Valid_to_date DATE NOT NULL,
	Flight_cost INT NOT NULL,
	PRIMARY KEY (Aircraft_type_code),
	FOREIGN KEY (Flight_number) REFERENCES airline.flight_schedules(Flight_number)
);

INSERT INTO airline.booking_agents (agent_id, agent_name, agent_details)
VALUES (045231, 'Sue Jones', 'Associate '),
	   (067456, 'Brad Collins', 'VP'),
	   (036524, 'Ann Rice', 'Associate')
;

INSERT INTO airline.payments (payment_id, payment_status_code, payment_date, payment_amount)
VALUES (6345, 05, '10-12-2023', 982),
	   (3267, 05, '02-04-2024', 473),
       (3585, 05, '05-11-2024', 564),
       (3563, 05, '08-06-2023', 638),
       (2573, 05,' 09-05-2024', 342)
;

INSERT INTO airline.reservation_payments (reservation_id, payment_id)
VALUES  (15457568, 6345),
        (24668346, 3267),
        (35635773, 3585),
        (36725613, 3563),
        (74677424, 2573)
;

INSERT INTO  airline.passengers (passenger_id, first_name, second_name, last_name, phone_number, email_address, address_lines, city, state_province_county, country, other_passenger_details)
VALUES  (7463826, 'Mila', 'Dina', 'Romanova', 19287256, 'mdr@live.com', '2782 1st St', 'New York', 'NY', 'USA', 'Member'),
        (5885922, 'Laura', 'Kelly', 'Juarez', 17389390, 'lkj25@gmail.com', '1080 Tree Cove','Dallas', 'TX', 'USA', 'Gold Status'),
        (9284293, 'Frank', 'Will', 'Craft', 18373845, 'fwk6@apple.com', '25 Smith St', 'Tempe', 'AZ', 'USA', 'guest checkout' ),
        (7375758, 'Jian', 'Li', 'Cho', 12384658, 'jlc@yahoo.com', '9876 Rue Verdun', 'Montreal','Quebec', 'CAN', 'Member'),
        (2772849, 'Joe', 'Preston', 'Hue', 13458293, 'jph@windows.com', '47 Turnpike Lane', 'Lafayette', 'LA', 'USA', 'Gold Status')
;

INSERT INTO airline.flight_schedules (flight_number, airline_code, usual_aircraft_type_code, origin_airport_code, destination_airport_code, departure_date_time, arrival_date_time)
VALUES 
    ('AA321', 'JK35748', 'B747', 'LFT', 'JFK', '2024-01-01 17:00:00', '2024-01-01 20:00:00'),
    ('AA642', 'JK26747', 'B360', 'MSY', 'DFW', '2024-01-02 14:00:00', '2024-01-02 15:00:00'),
    ('AA985', 'JK10832', 'S823', 'IAH', 'ATL', '2024-01-03 15:00:00', '2024-01-02 17:00:00')
;

INSERT INTO airline.itenerary_legs (reservation_id, leg_id)
VALUES 
    (15457568, 56432),
    (35635773, 656833),
    (36725613, 345795)
;

INSERT INTO airline.legs (leg_id, flight_number, airline_code, usual_aircraft_type_code, origin_airport_code, destination_airport_code, 
            departure_date_time, arrival_date_time, actual_departure_time, actual_arrival_time, departure_efficiency)
VALUES 
    (56432, 'AA321', 'JK35748', 'B747', 'LFT', 'JFK', '2024-01-01 17:00:00', '2024-01-01 20:00:00', '2024-01-01 17:30:00', '2024-01-01 20:30:00', FALSE),
    (656833, 'AA642', 'JK26747', 'B360', 'MSY', 'DFW', '2024-01-02 14:00:00', '2024-01-02 15:00:00', '2024-01-02 14:00:00', '2024-01-02 15:00:00', TRUE),
    (345795, 'AA985', 'JK10832', 'S823', 'IAH', 'ATL', '2024-01-03 15:00:00', '2024-01-02 17:00:00', '2024-01-03 15:00:00', '2024-01-02 17:00:00', TRUE)
;


----- Show total sales for a given flight 
SELECT SUM(airline.payments.payment_amount) AS sales_total
FROM airline.payments
JOIN airline.reservation_payments  ON airline.payments.Payment_id = airline.reservation_payments.Payment_id
JOIN airline.itenerary_reservations  ON airline.reservation_payments.Reservation_id = airline.itenerary_reservations.Reservation_id
WHERE airline.itenerary_reservations.Usual_aircraft_type_code = 'B360'; 

----- Show if a flight was on time or delayed

SELECT 
    Flight_number,
    Airline_code,
    Usual_aircraft_type_code,
    Origin_airport_code,
    Destination_airport_code,
    Departure_date_time,
    Actual_departure_time,
    Arrival_date_time,
    Actual_arrival_time,
CASE 
    WHEN Actual_departure_time <= Departure_date_time THEN 'On Time'
    ELSE 'Delayed'
    END AS Departure_Status,
CASE 
    WHEN Actual_arrival_time <= Arrival_date_time THEN 'On Time'
    ELSE 'Delayed'
    END AS Arrival_Status
FROM 
    airline.legs
ORDER BY 
    Flight_number;

----- Show all customers who have a seat on a given flight

SELECT 
    airline.passengers.Passenger_id,
    airline.passengers.First_name,
    airline.passengers.Second_name,
    airline.passengers.Last_name
FROM 
    airline.passengers 
JOIN 
    airline.itenerary_reservations ON airline.passengers.Passenger_id = airline.itenerary_reservations.Passenger_id
JOIN 
    airline.itenerary_legs  ON airline.itenerary_reservations.Reservation_id =  airline.itenerary_legs.Reservation_id
JOIN 
    airline.legs  ON  airline.itenerary_legs.Leg_id =  airline.legs.Leg_id
WHERE 
     airline.legs.Flight_number = 'AA321' 
;

----- Show all flights for a given airport

SELECT 
     airline.flight_schedules.Flight_number,
     airline.flight_schedules.Airline_code,
     airline.flight_schedules.Usual_aircraft_type_code,
     airline.flight_schedules.Origin_airport_code,
     airline.flight_schedules.Destination_airport_code,
     airline.flight_schedules.Departure_date_time,
     airline.flight_schedules.Arrival_date_time
FROM 
    airline.flight_schedules 
WHERE 
     airline.flight_schedules.Origin_airport_code = 'JFK'  
    OR  airline.flight_schedules.Destination_airport_code = 'JFK';

----- Create a View for Customer and Show Itenerary

CREATE VIEW customer_itinerary AS
SELECT 
    airline.itenerary_reservations.Reservation_id,
    airline.passengers.First_name,
    airline.passengers.Last_name,
    airline.itenerary_reservations.Agent_id,
    airline.itenerary_legs.Leg_id,
    airline.flight_schedules.Flight_number,
    airline.flight_schedules.Origin_airport_code,
    airline.flight_schedules.Destination_airport_code,
    airline.flight_schedules.Departure_date_time,
    airline.flight_schedules.Arrival_date_time
FROM 
    airline.itenerary_reservations
JOIN 
    airline.passengers ON airline.itenerary_reservations.Passenger_id = airline.passengers.Passenger_id
JOIN 
    airline.itenerary_legs ON airline.itenerary_reservations.Reservation_id = airline.itenerary_legs.Reservation_id
JOIN 
    airline.legs ON airline.itenerary_legs.Leg_id = airline.legs.Leg_id
JOIN 
    airline.flight_schedules ON airline.legs.Flight_number = airline.flight_schedules.Flight_number 
    AND airline.legs.Airline_code = airline.flight_schedules.Airline_code
    AND airline.legs.Usual_aircraft_type_code = airline.flight_schedules.Usual_aircraft_type_code
    AND airline.legs.Origin_airport_code = airline.flight_schedules.Origin_airport_code
    AND airline.legs.Destination_airport_code = airline.flight_schedules.Destination_airport_code
    AND airline.legs.Departure_date_time = airline.flight_schedules.Departure_date_time;


----- Show Flight Schedules

SELECT 
    Flight_number,
    Airline_code,
    Usual_aircraft_type_code,
    Origin_airport_code,
    Destination_airport_code,
    Departure_date_time,
    Arrival_date_time
FROM 
    airline.flight_schedules
ORDER BY 
    Departure_date_time;

