use amazon_cap;

Alter Table amazon
Add Column time_of_day Varchar(20);


Update amazon
Set time_of_day = 
		Case
			When Time between '05:00:00' And '11:59:59' Then 'Morning'
            When Time between '12:00:00' And '16:59:59' Then 'Afternoon'
            When Time between '17:00:00' And '20:59:59' Then 'Evening'
            Else 'Night'
		End;

Alter Table amazon
Add Column day_name Varchar(10);

Update amazon
Set day_name = Date_Format(Date, '%a');

Alter Table amazon
Add Column month_name Varchar(10);

Update amazon
Set month_name = Date_Format(Date, '%b');

# 1. What is the count of distinct cities in the dataset? --> 3
Select Count(distinct City) as total_City From amazon;

# 2. For each branch, what is the corresponding city?
Select Branch, City From amazon
Group By Branch, City;

# 3. What is the count of distinct product lines in the dataset?
Select Product_line, Count(*) as product_line_count from amazon
Group By Product_line
Order By product_line_count Desc;

# 4. Which payment method occurs most frequently?
Select Payment, Count(*) as payment_method_count from amazon
Group By Payment
Order By payment_method_count Desc;

# 5. Which product line has the highest sales? --> Electronic accessories - 971
Select Product_line, Sum(Quantity) as total_quantity_sold from amazon
Group By Product_line
Order By total_quantity_sold DESC
Limit 1;

# 6. How much revenue is generated each month?
Select month_name, Round(Sum(Total), 2) as monthly_revenue from amazon
Group By month_name
Order By monthly_revenue Desc;

# 7. In which month did the cost of goods sold reach its peak? --> Jan - 110754.16
Select month_name, Round(Sum(cogs), 2) as month_wise_cogs From amazon
Group BY month_name
Order By month_wise_cogs Desc;

# 8. Which product line generated the highest revenue? --> Food and beverages - 56144.84
Select Product_line, Round(Sum(Total), 2) as total_sales from amazon
Group By Product_line
Order By total_sales DESC
Limit 1;

# 9. In which city was the highest revenue recorded? --> Naypyitaw - 110568.71
Select City, Round(Sum(Total), 2) as city_revenue From amazon
Group By City
Order By city_revenue Desc
Limit 1;

# 10. Which product line incurred the highest Value Added Tax? --> Food and beverages - 2673.56
Select Product_line, Round(Sum(Vat), 2) as Value_added_tax from amazon
Group By Product_line
Order by Value_added_tax DESC
Limit 1;

# 11. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
Select 
		Product_line,
        Case
			When Sum(Quantity) > (Select Avg(sum_quantity) From (Select 
																		Sum(Quantity) as sum_quantity
																 From amazon
                                                                 Group By Product_line
                                                                 ) as sub_query
                                 ) Then "Good"
			Else "Bad"
		End as Sales_category
From amazon
Group By Product_line;

# 12. Identify the branch that exceeded the average number of products sold.
Select Branch, Sum(Quantity) as sum_quantity From amazon
Group By Branch
Having sum_quantity > (Select avg(sum_quantity) From (Select Sum(Quantity) as sum_quantity From amazon Group By Branch) as avg_quantity);

# 13. Which product line is most frequently associated with each gender?
Select Product_line, Gender, Productline_count
From (Select
			Product_line,
            Gender,
            Count(*) as Productline_count,
            rank() over (Partition By Gender Order By Count(*) Desc) as rnk
		From amazon
        Group By Product_line, Gender
	) as ranked
Where rnk = 1;

# 14. Calculate the average rating for each product line.
Select Product_line, Round(avg(rating), 2) avg_rating From amazon
Group By Product_line;

# 15. Count the sales occurrences for each time of day on every weekday.
Select time_of_day, Count(*) as sales_count from amazon
Group By time_of_day
Order By sales_count Desc;

#16. Identify the customer type contributing the highest revenue.
Select Customer_type, Round(Sum(Total), 2) as Revenue from amazon
Group By Customer_type
Order By Revenue Desc
limit 1;

# 17. Determine the city with the highest VAT percentage.
Select City, Round(Sum(Vat) / Sum(total) * 100, 2) as Vat_percentage From amazon
Group By City
Order By Vat_percentage Desc
Limit 1;

# 18. Identify the customer type with the highest VAT payments.
Select Customer_type, Round(Sum(Vat), 2) as total_Vat From amazon
Group By Customer_type
Order By total_Vat Desc
Limit 1;

# 19. What is the count of distinct customer types in the dataset?
Select Count(Distinct Customer_type) as Unique_Customer_Count From amazon;

# 20. What is the count of distinct payment methods in the dataset?
Select Count(Distinct Payment) as unique_payment_method From amazon;

# 21. Which customer type occurs most frequently?
Select Customer_type, Count(*) as count_customer_type  From amazon
Group By Customer_type
Order BY count_customer_type Desc
Limit 1;

# 22. Identify the customer type with the highest purchase frequency.
Select Customer_type, Sum(Quantity) as purchase_frequency From amazon
Group By Customer_type
Order By purchase_frequency Desc
Limit 1;

# 23. Determine the predominant gender among customers.
Select Gender, Count(Gender) as gender_count From amazon
Group By Gender
Order By gender_count Desc
Limit 1;

# 24. Examine the distribution of genders within each branch.
Select Branch, Gender, Count(*) as Distribution_Count From amazon
Group By Branch, Gender;

# 25. Identify the time of day when customers provide the most ratings.
Select time_of_day, Count(*) as rating_count From amazon
Group By time_of_day
Order By rating_count Desc;

# 26. Determine the time of day with the highest customer ratings for each branch.
Select Branch, time_of_day
From (Select 
			Branch,
            time_of_day,
            avg(Rating) as avg_rating,
            rank() over (Partition By Branch Order By Avg(Rating) Desc) as rnk
	 From amazon
     Group By Branch, time_of_day
     ) as ranked
Where rnk = 1;

# 27. Identify the day of the week with the highest average ratings.
Select day_name, Round(Avg(Rating), 2) as avg_rating From amazon
Group By day_name
Order By avg_rating Desc
Limit 1;

# 28. Determine the day of the week with the highest average ratings for each branch.
Select day_name, Branch, avg_rating
From (
		Select 
				day_name,
				Branch,
				Round(Avg(Rating), 2) as avg_rating,
				rank() over (Partition By Branch Order By Avg(Rating) Desc) as rnk
		From amazon
		Group By day_name, Branch
) as ranked
Where rnk = 1;



Select * from amazon;





















