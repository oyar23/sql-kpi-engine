-- Análisis de Cohortes de Retención
WITH cohortes AS (
  -- Definir cohorte: mes de primera compra de cada cliente
  SELECT 
    "Customer ID" as customer_id,
    DATE_TRUNC('month', MIN(CAST(InvoiceDate AS DATE))) as cohort_mes
  FROM ventas
  GROUP BY "Customer ID"
),
actividad_mensual AS (
  -- Actividad mensual de cada cliente
  SELECT 
    c.customer_id,
    c.cohort_mes,
    DATE_TRUNC('month', CAST(v.InvoiceDate AS DATE)) as mes_actividad,
    -- Calcular período (meses desde cohorte)
    EXTRACT(YEAR FROM AGE(DATE_TRUNC('month', CAST(v.InvoiceDate AS DATE)), c.cohort_mes)) * 12 +
    EXTRACT(MONTH FROM AGE(DATE_TRUNC('month', CAST(v.InvoiceDate AS DATE)), c.cohort_mes)) as mes_numero
  FROM cohortes c
  JOIN ventas v ON c.customer_id = v."Customer ID"
  GROUP BY c.customer_id, c.cohort_mes, DATE_TRUNC('month', CAST(v.InvoiceDate AS DATE))
),
cohort_size AS (
  -- Tamaño inicial de cada cohorte
  SELECT 
    cohort_mes,
    COUNT(DISTINCT customer_id) as total_clientes
  FROM cohortes
  GROUP BY cohort_mes
)
-- Matriz de retención final
SELECT 
  a.cohort_mes,
  cs.total_clientes as cohort_size,
  a.mes_numero,
  COUNT(DISTINCT a.customer_id) as clientes_activos,
  ROUND(100.0 * COUNT(DISTINCT a.customer_id) / cs.total_clientes, 2) as retencion_porcentaje
FROM actividad_mensual a
JOIN cohort_size cs ON a.cohort_mes = cs.cohort_mes
GROUP BY a.cohort_mes, cs.total_clientes, a.mes_numero
ORDER BY a.cohort_mes, a.mes_numero;