WITH cohortes AS (
    -- 1. Definir la Cohorte (Mes de primera compra) para cada cliente
    SELECT 
        "Customer ID" as customer_id,
        DATE_TRUNC('month', MIN(CAST(InvoiceDate AS DATE))) as cohort_mes
    FROM ventas
    GROUP BY "Customer ID"
),
actividad_mensual AS (
    -- 2. Calcular el Número de Mes de Actividad
    SELECT 
        c.customer_id,
        c.cohort_mes,
        DATE_TRUNC('month', CAST(v.InvoiceDate AS DATE)) as mes_actividad,
        -- Calcular la diferencia de meses (Mes de Vida del Cliente)
        EXTRACT(YEAR FROM AGE(DATE_TRUNC('month', CAST(v.InvoiceDate AS DATE)), c.cohort_mes)) * 12 +
        EXTRACT(MONTH FROM AGE(DATE_TRUNC('month', CAST(v.InvoiceDate AS DATE)), c.cohort_mes)) as mes_numero
    FROM cohortes c
    JOIN ventas v ON c.customer_id = v."Customer ID"
    GROUP BY 1, 2, 3 
),
cohort_size AS (
    -- 3. Calcular el Tamaño Inicial de la Cohorte (Mes 0)
    SELECT 
        cohort_mes, 
        COUNT(DISTINCT customer_id) as tamaño_inicial
    FROM actividad_mensual
    WHERE mes_numero = 0
    GROUP BY cohort_mes
)
-- 4. Calcular la Tasa de Churn Acumulada
SELECT 
    a.cohort_mes,
    a.mes_numero,
    COUNT(DISTINCT a.customer_id) as clientes_retenidos,
    cs.tamaño_inicial,
    -- Churn Acumulado: (Tamaño Inicial - Retenidos) / Tamaño Inicial * 100
    ROUND(100.0 * (cs.tamaño_inicial - COUNT(DISTINCT a.customer_id)) / cs.tamaño_inicial, 2) as tasa_churn_acumulada
FROM actividad_mensual a
JOIN cohort_size cs ON a.cohort_mes = cs.cohort_mes
GROUP BY a.cohort_mes, a.mes_numero, cs.tamaño_inicial 
ORDER BY a.cohort_mes, a.mes_numero; 