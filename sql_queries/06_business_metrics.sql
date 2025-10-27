WITH customer_monthly_revenue AS (
    -- Aseguramos que tenemos cliente, mes y el ingreso mensual
    SELECT 
        "Customer ID" as customer_id,
        DATE_TRUNC('month', CAST(InvoiceDate AS DATE)) as mes,
        SUM(Quantity * Price) as ingreso_mensual
    FROM ventas
    GROUP BY 1, 2
),
monthly_metrics AS (
    -- Agrupamos por mes para tener las métricas de ese período
    SELECT 
        mes,
        COUNT(DISTINCT customer_id) as clientes_activos,
        SUM(ingreso_mensual) as revenue_mensual,
        AVG(ingreso_mensual) as revenue_por_cliente -- ARPU de ese mes
    FROM customer_monthly_revenue
    GROUP BY mes
)
SELECT 
    -- Cálculo de promedios generales sobre todos los meses
    AVG(clientes_activos) as avg_clientes_activos,
    AVG(revenue_mensual) as avg_revenue_mensual,
    AVG(revenue_por_cliente) as avg_arpu,
    -- (Suma de Revenue Total) / (Suma de Clientes Activos) = CLV simple
    SUM(revenue_mensual) / SUM(clientes_activos) as ltv_estimado_simple
FROM monthly_metrics;