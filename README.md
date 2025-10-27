# 📊 Análisis de Métricas de Negocio con SQL Avanzado

## 🎯 Objetivo del Proyecto
Implementar un análisis completo de métricas de negocio utilizando SQL avanzado sobre datos transaccionales de e-commerce, demostrando habilidades en análisis de datos, optimización de queries y comunicación de insights de negocio.

## 🛠️ Stack Tecnológico
- **Base de Datos**: DuckDB
- **Lenguaje de Consulta**: SQL Avanzado (CTEs, Window Functions, LAG)
- **Lenguaje de Programación**: Python 
- **Herramientas**: Jupyter Lab, Pandas, Git/GitHub
- **Metodología**: Agile/Scrum con Sprints


## 📈 Hallazgos Clave de Negocio (Business Insights)

La ejecución de las consultas SQL avanzadas reveló información crítica sobre la salud y el comportamiento de la base de clientes.

1. Rentabilidad y Valor del Cliente (LTV/CAC)

    LTV Promedio Histórico: El Valor de Vida del Cliente (LTV) promedio es notablemente alto, superando los £3,000.

    Ratio LTV/CAC: La simulación de Costo de Adquisición (CAC) mostró un Ratio LTV/CAC superior a 60:1. Esto indica que la adquisición de clientes es extremadamente rentable y sugiere que la empresa podría invertir agresivamente en marketing.

2. Retención y Abandono (Churn)

    Retención a Corto Plazo: Existe una caída abrupta en la retención después del primer mes de compra, lo que subraya la necesidad de una estrategia de onboarding post-compra más efectiva.

    Retención Sostenida: Las cohortes que logran mantenerse activas después del Mes 3 demuestran una lealtad sorprendentemente alta, con tasas de retención que se estabilizan por encima del 20% a largo plazo.

3. Segmentación y Oportunidades

    Cliente de Mayor Valor: La segmentación bidimensional identificó al grupo VIP Short-term (alto gasto en poco tiempo) como el de mayor valor promedio.

    Riesgo Estructural: La concentración de todos los clientes en el área 'Short-term' (menos de 30 días de vida útil) es una alerta roja. Esto confirma que el negocio está basado en transacciones de impulso, no en relaciones duraderas.

4. Crecimiento (Growth Accounting)

    El Ingreso por Expansión (clientes que aumentan su gasto) es el principal motor de crecimiento, superando significativamente el ingreso de clientes nuevos y compensando la Contracción de valor.
