-- Análisis de Revenue Mensual por Cliente
WITH monthly_revenue AS (
  SELECT 
    "Customer ID" as customer_id,
    DATE_TRUNC('month', CAST(InvoiceDate AS DATE)) as mes,
    SUM(Quantity * Price) as ingreso_mensual
  FROM ventas
  GROUP BY "Customer ID", DATE_TRUNC('month', CAST(InvoiceDate AS DATE))
),
revenue_lag AS (
  SELECT 
    customer_id,
    mes,
    ingreso_mensual,
    LAG(ingreso_mensual) OVER (PARTITION BY customer_id ORDER BY mes) as ingreso_anterior
  FROM monthly_revenue
)
SELECT 
  mes,
  customer_id,
  ingreso_mensual,
  CASE 
    WHEN ingreso_anterior IS NULL THEN 'Nuevo'
    WHEN ingreso_mensual > ingreso_anterior THEN 'Expansion'
    WHEN ingreso_mensual < ingreso_anterior THEN 'Contraccion'
    ELSE 'Mantenimiento'
  END as estado_cliente,
  CASE 
    WHEN ingreso_anterior IS NULL THEN ingreso_mensual
    ELSE ingreso_mensual - ingreso_anterior
  END as cambio_revenue
FROM revenue_lag
ORDER BY customer_id, mes;