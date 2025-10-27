-- Análisis de Comportamiento del Cliente
WITH customer_metrics AS (
  SELECT 
    "Customer ID" as customer_id,
    COUNT(*) as total_transacciones,
    SUM(Quantity * Price) as total_gastado,
    AVG(Quantity * Price) as ticket_promedio,
    COUNT(DISTINCT DATE_TRUNC('month', CAST(InvoiceDate AS DATE))) as meses_activo,
    MIN(CAST(InvoiceDate AS DATE)) as primera_compra,
    MAX(CAST(InvoiceDate AS DATE)) as ultima_compra,
    EXTRACT(DAY FROM AGE(MAX(CAST(InvoiceDate AS DATE)), MIN(CAST(InvoiceDate AS DATE)))) as duracion_dias
  FROM ventas
  GROUP BY "Customer ID"
),
customer_segments AS (
  SELECT 
    *,
    CASE 
      WHEN total_gastado > 1000 THEN 'VIP'
      WHEN total_gastado > 500 THEN 'Premium'
      WHEN total_gastado > 100 THEN 'Regular'
      ELSE 'Light'
    END as segmento,
    CASE 
      WHEN duracion_dias > 180 THEN 'Long-term'
      WHEN duracion_dias > 30 THEN 'Medium-term'
      ELSE 'Short-term'
    END as duracion_tipo
  FROM customer_metrics
)
SELECT 
  segmento,
  duracion_tipo,
  COUNT(*) as total_clientes,
  ROUND(AVG(total_gastado), 2) as gasto_promedio,
  ROUND(AVG(ticket_promedio), 2) as ticket_promedio,
  ROUND(AVG(duracion_dias), 1) as duracion_promedio_dias
FROM customer_segments
GROUP BY segmento, duracion_tipo
ORDER BY segmento, duracion_tipo;