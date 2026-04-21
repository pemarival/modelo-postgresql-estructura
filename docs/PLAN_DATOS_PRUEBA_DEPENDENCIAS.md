# Plan de Datos de Prueba por Dependencias

## Objetivo
Construir un flujo de carga de datos de prueba ordenado y coherente con las dependencias del modelo.

## Orden de insercion por dependencias

1. Referenciales base:
- `time_zone`, `continent`, `country`, `state_province`, `city`, `district`, `address`, `currency`
- Script: `03_dml/00_seed_data/001_reference_data.sql`

2. Identidad y seguridad:
- `airline`, `person_type`, `document_type`, `contact_type`, `person`, `person_document`, `person_contact`, `user_status`, `user_account`, `user_role`
- Script: `03_dml/00_seed_data/002_identity_security.sql`

3. Cliente y lealtad:
- `customer_category`, `benefit_type`, `loyalty_program`, `loyalty_tier`, `customer`, `loyalty_account`, `loyalty_account_tier`, `miles_transaction`, `customer_benefit`
- Script: `03_dml/00_seed_data/003_customer_loyalty.sql`

4. Operaciones aeroportuarias y vuelo:
- `airport`, `terminal`, `boarding_gate`, `runway`, `airport_regulation`, `aircraft_manufacturer`, `aircraft_model`, `cabin_class`, `aircraft`, `aircraft_cabin`, `aircraft_seat`, `maintenance_provider`, `maintenance_type`, `maintenance_event`, `flight_status`, `delay_reason_type`, `flight`, `flight_segment`, `flight_delay`
- Script: `03_dml/00_seed_data/004_operations.sql`

5. Flujo comercial y financiero:
- `reservation_status`, `sale_channel`, `fare_class`, `fare`, `ticket_status`, `reservation`, `reservation_passenger`, `sale`, `ticket`, `ticket_segment`, `seat_assignment`, `baggage`, `boarding_group`, `check_in_status`, `check_in`, `boarding_pass`, `boarding_validation`, `payment_status`, `payment_method`, `payment`, `payment_transaction`, `refund`, `tax`, `exchange_rate`, `invoice_status`, `invoice`, `invoice_line`
- Script: `03_dml/00_seed_data/005_commercial_financial.sql`

6. Validaciones de dependencia:
- Cobertura minima por dominio.
- Verificacion de relaciones FK criticas.
- Script: `03_dml/01_validations/001_dependency_checks.sql`

## Scripts de insercion documentados

Los scripts se encuentran bajo `03_dml/00_seed_data` y contienen:
- Comentarios de objetivo por bloque.
- Inserts idempotentes (`ON CONFLICT` o `NOT EXISTS`) para poder re-ejecutar.
- Carga incremental por jerarquia de dependencias.

## Pruebas unitarias asociadas a dependencias

Las validaciones incluidas en `03_dml/01_validations/001_dependency_checks.sql` verifican:
- Existencia de registros clave semilla.
- Integridad de dependencias en `customer`, `reservation_passenger`, `ticket_segment`, `payment`, `invoice_line`.
- Falla controlada con `RAISE EXCEPTION` ante inconsistencias.

## Registro tecnico de seguimiento

| Paso | Artefacto | Estado | Nota tecnica |
|---|---|---|---|
| 1 | `03_dml/changelog.yaml` | Completado | Orquesta carga de seed y validaciones. |
| 2 | `03_dml/00_seed_data/0000changelog.yaml` | Completado | Define orden de carga por dependencia funcional. |
| 3 | `03_dml/00_seed_data/001..005_*.sql` | Completado | Dataset base transversal para pruebas integrales. |
| 4 | `03_dml/01_validations/0000changelog.yaml` | Completado | Encadena pruebas unitarias de dependencias. |
| 5 | `03_dml/01_validations/001_dependency_checks.sql` | Completado | Assert de integridad referencial y cobertura minima. |

## Ejecucion recomendada

1. Validar changelog:
- `liquibase validate`

2. Cargar datos de prueba:
- `liquibase update`

3. Ejecutar solo DML de prueba (opcional):
- `liquibase --changelog-file=03_dml/changelog.yaml update`
