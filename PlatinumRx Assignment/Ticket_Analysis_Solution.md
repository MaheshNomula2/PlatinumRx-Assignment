# Spreadsheet Proficiency – Detailed Solution Guide
## File: Ticket_Analysis.xlsx

---

## Sheet Layout

The workbook has two sheets:
| Sheet name  | Contents                                      |
|-------------|-----------------------------------------------|
| `ticket`    | ticket_id, created_at, closed_at, outlet_id, cms_id |
| `feedbacks` | cms_id, feedback_at, feedback_rating, ticket_created_at |

---

## Question 1 – Populate `ticket_created_at` in the `feedbacks` sheet

### Goal
Pull the `created_at` timestamp from the `ticket` sheet into the matching row of the `feedbacks` sheet, using `cms_id` as the common key.

### Formula (VLOOKUP)

Place this in cell **D2** of the `feedbacks` sheet and drag/fill down:

```excel
=VLOOKUP(A2, ticket!$E:$B, 2, FALSE)
```

| Argument        | Value           | Explanation                                                       |
|-----------------|-----------------|-------------------------------------------------------------------|
| `lookup_value`  | `A2`            | The `cms_id` in the current feedbacks row                        |
| `table_array`   | `ticket!$E:$B`  | Columns E (cms_id) through B (created_at) in the ticket sheet     |
| `col_index_num` | `2`             | Return the 2nd column of the range (created_at)                  |
| `range_lookup`  | `FALSE`         | Exact match only                                                  |

> **Note:** In the ticket sheet, `cms_id` is column E and `created_at` is column B.  
> VLOOKUP requires the lookup column to be the **leftmost** in `table_array`.  
> Since cms_id (E) comes after created_at (B), you have two clean options:

#### Option A – Use INDEX-MATCH (recommended, no column-order restriction)

```excel
=INDEX(ticket!$B:$B, MATCH(A2, ticket!$E:$E, 0))
```

| Part           | Meaning                                                  |
|----------------|----------------------------------------------------------|
| `INDEX(ticket!$B:$B, …)` | Return a value from the `created_at` column          |
| `MATCH(A2, ticket!$E:$E, 0)` | Find the row where cms_id matches exactly        |

#### Option B – Use XLOOKUP (Excel 365 / Google Sheets)

```excel
=XLOOKUP(A2, ticket!$E:$E, ticket!$B:$B, "Not Found")
```

This is the most readable: search A2 in the cms_id column, return the corresponding created_at.

---

## Question 2 – Outlet-wise count of tickets created AND closed on:

### 2a. The SAME DAY

Two timestamps are on the same day if their **date parts** (integer portion) are equal.

#### Step 1 – Add a helper column in the `ticket` sheet

In column F (header: `Same_Day`):

```excel
=IF(INT(B2) = INT(C2), "Yes", "No")
```

`INT()` strips the time portion from an Excel datetime serial, leaving only the date.

#### Step 2 – Count per outlet using COUNTIFS

In a summary table (e.g., Sheet3 or a section of the ticket sheet):

```excel
=COUNTIFS(ticket!$D:$D, outlet_id_cell, ticket!$F:$F, "Yes")
```

Or use a **Pivot Table**:
- Rows  → `outlet_id`
- Values → Count of `Same_Day` filtered to "Yes"

---

### 2b. The SAME HOUR of the SAME DAY

Both conditions must be true simultaneously.

#### Step 1 – Add helper columns in `ticket`

Column F – `Same_Day` (reuse from above):
```excel
=IF(INT(B2) = INT(C2), "Yes", "No")
```

Column G – `Same_Hour` (checks day AND hour together):
```excel
=IF(AND(INT(B2)=INT(C2), HOUR(B2)=HOUR(C2)), "Yes", "No")
```

`HOUR()` extracts the hour (0–23) from the time portion of the datetime.

#### Step 2 – Count per outlet using COUNTIFS

```excel
=COUNTIFS(ticket!$D:$D, outlet_id_cell, ticket!$G:$G, "Yes")
```

#### Alternative – Single-formula without helper columns

Same day count:
```excel
=COUNTIFS(ticket!$D:$D, outlet_id_cell,
          ticket!$B:$B, ">="&DATE(YEAR(ref_date),MONTH(ref_date),DAY(ref_date)),
          ticket!$C:$C, ">="&DATE(YEAR(ref_date),MONTH(ref_date),DAY(ref_date)))
```

For same hour, the helper column approach is cleaner and easier to audit.

---

## Summary Table Structure (suggested)

| outlet_id | Tickets Same Day | Tickets Same Hour |
|-----------|-----------------|------------------|
| wrqy-juv-978 | `=COUNTIFS(...)` | `=COUNTIFS(...)` |
| 8woh-k3u-23b | `=COUNTIFS(...)` | `=COUNTIFS(...)` |
| ...          | ...              | ...              |
