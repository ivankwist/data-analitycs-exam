/*

2 - Analytics

Problem

Objective: Explain what the following SQL query does and how can be used as a
trigger in the business side.

Plus: rewrite the query without the window function.

*/

WITH events AS (
  SELECT
    device_id,
    time_stamp,
    LEAD(time_stamp) OVER (PARTITION BY device_id ORDER BY time_stamp) as next_time_stamp
    FROM events_table
    WHERE month = '201908'
    AND app_id = 1
    AND event_id = 4
),
per_event AS (
  SELECT
    device_id,
    DATE_DIFF('second', time_stamp, next_time_stamp) as time_diff
    FROM events
)
SELECT
  device_id,
  AVG(time_diff) as avg_per_user
FROM per_event
GROUP BY 1;

/*

Solution

This query gets the average time difference in seconds between each time an user
performed a certain event (action: i.e. open, registration) on a certain app (client)
on August 2019.

+------------+----------------------+
| device id  | avg_per_user         |
+------------+----------------------+
| 1          | 1283                 |
| 2          | 2510                 |
| 2          | 7143                 |
| 3          | 12843                |
+------------+----------------------+

This type of information could be useful to check, for example, how often
users open the client's app. Said information could potentially describe the
level of investment users have on a certain app.

If most of the records are above a certain threshold (for instance, users only
use the app on a weekly basis) a trigger could come in handy.

At the moment I wasn't able to come up with an alternative to using the window
function, but I will take this as an opportunity to brush up on my SQL skills.

*/
