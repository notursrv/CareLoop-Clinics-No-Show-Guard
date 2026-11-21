
-- CARELOOP CLINICS: NO-SHOW GUARD
-- PART 2: SQL ANALYTICS

-- TASK 2.2: Clinic-wise no-show analysis (95+ appointments)


SELECT
    c.clinic_name,
    c.city,
    COUNT(a.appointment_id) AS appointments,
    SUM(a.no_show) AS no_shows,
    ROUND(100.0 * SUM(a.no_show) / COUNT(*), 1) AS no_show_pct
FROM clinics c
JOIN appointments a
    ON c.clinic_id = a.clinic_id
GROUP BY
    c.clinic_id,
    c.clinic_name,
    c.city
HAVING COUNT(a.appointment_id) >= 95
ORDER BY no_show_pct DESC;


-- TASK 2.2: All clinics without HAVING


SELECT
    c.clinic_name,
    c.city,
    COUNT(a.appointment_id) AS appointments,
    SUM(a.no_show) AS no_shows,
    ROUND(100.0 * SUM(a.no_show) / COUNT(*), 1) AS no_show_pct
FROM clinics c
JOIN appointments a
    ON c.clinic_id = a.clinic_id
GROUP BY
    c.clinic_id,
    c.clinic_name,
    c.city
ORDER BY no_show_pct DESC;


-- TASK 2.3: Lead-time analysis


SELECT
    CASE
        WHEN lead_days <= 7 THEN '1-7'
        WHEN lead_days <= 14 THEN '8-14'
        WHEN lead_days <= 30 THEN '15-30'
        ELSE '31+'
    END AS lead_band,

    COUNT(*) AS appointments,

    SUM(no_show) AS no_shows,

    ROUND(
        100.0 * SUM(no_show) / COUNT(*),
        1
    ) AS no_show_pct

FROM appointments

GROUP BY lead_band

ORDER BY MIN(lead_days);


-- TASK 2.4: Monthly no-show trend


WITH monthly AS (

    SELECT
        SUBSTR(appt_date, 1, 7) AS month,

        COUNT(*) AS appointments,

        ROUND(
            100.0 * SUM(no_show) / COUNT(*),
            1
        ) AS no_show_pct

    FROM appointments

    GROUP BY SUBSTR(appt_date, 1, 7)
),

monthly_changes AS (

    SELECT
        month,
        appointments,
        no_show_pct,

        LAG(no_show_pct) OVER (
            ORDER BY month
        ) AS previous_month_rate

    FROM monthly
)

SELECT
    month,
    appointments,
    no_show_pct,

    ROUND(
        no_show_pct - previous_month_rate,
        1
    ) AS change_percentage_points

FROM monthly_changes

ORDER BY month;


-- TASK 2.5: Clinic ranking within each city


WITH clinic_rates AS (

    SELECT
        c.clinic_name,
        c.city,

        ROUND(
            100.0 * SUM(a.no_show) / COUNT(*),
            1
        ) AS no_show_pct

    FROM clinics c

    JOIN appointments a
        ON c.clinic_id = a.clinic_id

    GROUP BY
        c.clinic_id,
        c.clinic_name,
        c.city
)

SELECT

    clinic_name,
    city,
    no_show_pct,

    RANK() OVER (
        PARTITION BY city
        ORDER BY no_show_pct DESC
    ) AS rank_in_city,

    CASE
        WHEN no_show_pct > (
            SELECT AVG(no_show) * 100.0
            FROM appointments
        ) THEN 'above'

        WHEN no_show_pct < (
            SELECT AVG(no_show) * 100.0
            FROM appointments
        ) THEN 'below'

        ELSE 'equal'
    END AS vs_overall

FROM clinic_rates

ORDER BY city, rank_in_city;


-- DUPLICATE PRIMARY KEY TEST
-- INSERT INTO appointments (appointment_id) VALUES ('A0001');

-- SQLite error received:
-- UNIQUE constraint failed: appointments.appointment_id
