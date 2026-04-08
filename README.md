PlatinumRx Data Analyst Assignment
Repository Structure
```
PlatinumRx_Assignment/
│
├── SQL/
│   ├── 01_Hotel_Schema_Setup.sql    # CREATE TABLE + INSERT for hotel system
│   ├── 02_Hotel_Queries.sql         # Part A – 5 hotel analysis queries
│   ├── 03_Clinic_Schema_Setup.sql   # CREATE TABLE + INSERT for clinic system
│   └── 04_Clinic_Queries.sql        # Part B – 5 clinic analysis queries
│
├── Spreadsheets/
│   └── Ticket_Analysis_Solution.md  # Detailed formula guide (VLOOKUP / COUNTIFS)
│
├── Python/
│   ├── 01_Time_Converter.py         # Convert minutes → "X hrs Y minutes"
│   └── 02_Remove_Duplicates.py      # Remove duplicate chars from a string
│
└── README.md
```
---
Phase 1: SQL
Tools Used
MySQL (compatible syntax; minor tweaks needed for PostgreSQL – replace `DATE_FORMAT` with `TO_CHAR`)
Window functions: `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`
Hotel System (Part A)
Q#	Technique
Q1	`ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY booking_date DESC)` to get last booking per user
Q2	3-table JOIN (`bookings → booking_commercials → items`), `SUM(qty * rate)`, filter by Nov 2021
Q3	Same join, filter Oct 2021, `HAVING SUM(...) > 1000`
Q4	CTE aggregates qty per month+item; `RANK()` finds most/least
Q5	CTE aggregates bill per customer+month; `DENSE_RANK()` picks rank 2
Clinic System (Part B)
Q#	Technique
Q1	`GROUP BY sales_channel`, `SUM(amount)`
Q2	`GROUP BY uid`, `SUM(amount)`, `ORDER BY DESC LIMIT 10`
Q3	Two CTEs (revenue + expense), `LEFT JOIN` on month, computed profit + CASE label
Q4	CTE builds per-clinic profit for the month; `RANK()` picks top per city
Q5	Same CTE; `DENSE_RANK()` ASC picks rank 2 (second least) per state
---
Phase 2: Spreadsheets
Q1 – Populate `ticket_created_at`
Formula: `=INDEX(ticket!$B:$B, MATCH(A2, ticket!$E:$E, 0))`
INDEX-MATCH preferred over VLOOKUP because the lookup column (cms_id = col E) is to the right of the return column (created_at = col B).
Q2 – Outlet-wise same-day / same-hour counts
Helper column `Same_Day`: `=IF(INT(created_at) = INT(closed_at), "Yes", "No")`
Helper column `Same_Hour`: `=IF(AND(INT(B2)=INT(C2), HOUR(B2)=HOUR(C2)), "Yes", "No")`
Count: `=COUNTIFS(outlet_id_col, outlet, helper_col, "Yes")`
---
Phase 3: Python
Q1 – Time Converter
```
hours   = total_minutes // 60
minutes = total_minutes  % 60
```
Integer division (`//`) gives whole hours; modulo (`%`) gives the remainder.
Q2 – Remove Duplicates
```python
result = ""
for char in input_string:
    if char not in result:
        result += char
```
Loop maintains insertion order; membership test (`in`) prevents re-adding seen characters.
---
Assumptions
All datetime columns store values in standard `YYYY-MM-DD HH:MM:SS` format.
"Most/Least ordered" in Q4 refers to total quantity of items ordered.
"Most valuable customers" in clinic Q2 means highest total spend.
Profit = Revenue − Expenses. A zero-expense month is not loss-making.
In Q5 (Hotel), `DENSE_RANK` is used so ties at rank 1 don't skip rank 2.
