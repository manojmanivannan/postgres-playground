# Postgres Playground
It provides a docker container version of postgres server with preloaded data to play around with SQL


## Usage
If you have `curl`, `wget`, `make` , `docker` and `docker-compose` installed, then running this is a breeze. 
If not, check these pages for installing these tools in windows
1. https://gnuwin32.sourceforge.net/packages/wget.htm
2. https://gnuwin32.sourceforge.net/packages/make.htm
3. https://docs.docker.com/desktop/install/windows-install/
4. https://docs.docker.com/compose/install/

```
Usage
        make dk_start   - Start the docker containers
		make dk_stop    - Stop the docker containers
		make download   - Download extra dataset from web
		make all        - Download extra dataset from web and Start the docker containers
		make clean      - Stop and remove docker containers
```

## Questions
<details>
<summary>E-commerce</summary>


1. Retrieve a list of all users who have made at least one order.
2. Calculate the total revenue generated by the e-commerce website.
3. Find the user who has placed the most orders.
4. Identify the top-selling product category.
5. List the five most recent orders, including the user's name and email.
6. Calculate the average order total for each product category.
7. Determine the user with the highest lifetime spending.
8. Find the products that have never been ordered.
9. Calculate the total quantity of each product sold.
10. List the users who registered more than a year ago and have not placed any orders.
11. Rank Users by Total Spending: Rank users based on their total spending in descending order.
12. Calculate User Order Frequency: Find the average time between orders for each user.
13. Dense Rank Products by Category: Determine the dense rank of products within each category based on their prices.
14. Calculate Running Total: Calculate the running total of revenue generated by product sales.
15. Find the Nth Highest Order Total: Retrieve the user and order details for the 5th highest order total.
16. Identify Users with Duplicate Emails: Find users with the same email address and provide a count of occurrences.
17. Calculate the Median Order Total: Determine the median order total for all orders.
18. Find Orders with the Highest Quantity: Identify orders with the highest quantity of products.
19. Retrieve the Most Recent Order for Each User: Find the most recent order for each user.
20. Calculate the User's Lifetime Value: Calculate the lifetime value of each user, defined as the total spending on the website by the user over their lifetime.
</details>

<details>
<summary>Patient logs</summary>

1. Find the top 2 accounts with the maximum number of unique patients on a monthly basis.
Note: Prefer the account id with the least value in case of same number of unique patients
</details>


<details>
<summary>Login details</summary>

1. From the login_details table, fetch the users who logged in consecutively 3 or more times.
</details>


<details>
<summary>Inflation details</summary>

1. Find the top 5 countries who had the highest inflation rates and whose inflation increased or remained same for 3 or more consecutive years, optionally, give the year range where this increase occurred
</details>

<details>
<summary>Olympics history</summary>

1. How many olympics games have been held?
2. List down all Olympics games held so far.
3. Mention the total no of nations who participated in each olympics game?
4. Which year saw the highest and lowest no of countries participating in olympics?
5. Which nation has participated in all of the olympic games?
6. Identify the sport which was played in all summer olympics.
7. Which Sports were just played only once in the olympics?
8. Fetch the total no of sports played in each olympic games.
9. Fetch details of the oldest athletes to win a gold medal.
10. Find the Ratio of male and female athletes participated in all olympic games.
11. Fetch the top 5 athletes who have won the most gold medals.
12. Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
13. Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
14. List down total gold, silver and bronze medals won by each country.
15. List down total gold, silver and bronze medals won by each country corresponding to each olympic games.
16. Identify which country won the most gold, most silver and most bronze medals in each olympic games.
17. Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.
18. Which countries have never won gold medal but have won silver/bronze medals?
19. In which Sport/event, India has won highest medals.
20. Break down all olympic games where india won medal for Hockey and how many medals in each olympic games.
</details>


