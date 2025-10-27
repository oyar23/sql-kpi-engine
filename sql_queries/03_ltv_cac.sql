-- Cálculo de Lifetime Value (LTV) por Cliente
WITH customer_ltv AS (
  SELECT 
    "Customer ID" as customer_id,
    SUM(Quantity * Price) as lifetime_value,
    COUNT(DISTINCT DATE_TRUNC('month', CAST(InvoiceDate AS DATE))) as meses_activo,
    MIN(CAST(InvoiceDate AS DATE)) as primera_compra,
    MAX(CAST(InvoiceDate AS DATE)) as ultima_compra
  FROM ventas
  GROUP BY "Customer ID"
),
ltv_stats AS (
  SELECT
    COUNT(*) as total_clientes,
    AVG(lifetime_value) as ltv_promedio,
    AVG(meses_activo) as meses_activo_promedio,
    SUM(lifetime_value) as ltv_total
  FROM customer_ltv
)
SELECT 
  lt.*,
  ls.ltv_promedio,
  ls.meses_activo_promedio,
  ROUND(lt.lifetime_value / ls.ltv_promedio, 2) as ratio_ltv_vs_promedio
FROM customer_ltv lt
CROSS JOIN ltv_stats ls
ORDER BY lifetime_value DESC;