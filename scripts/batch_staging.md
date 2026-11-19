Bronze-to-Silver validation without staging tables

```bash
dbt build
```

Each Bronze model has one bronze_silver_rules test. It selects Bronze rows newer
than MAX(source_updated_at) in the corresponding existing Silver table, applies
the same typed projection as the Silver model, and checks required values and
accepted values. Orders also validates the existing 0..100000 amount rule before
merging. Tests return validation_errors with the reason for each rejected event.

macros/silver_input.sql is shared between tests and Silver: numeric IDs remain
INT, amount DECIMAL(18,2), dates DATE, timestamps TIMESTAMP. Bronze stays raw.
No staging table or batch variable is required. On first load or full refresh,
all Bronze rows are selected. Invalid timestamps remain visible to validation.

Use dbt build: the tests are attached to the Bronze models, so failed validation
blocks dependent Silver loads. dbt run alone does not execute these gates.
Global uniqueness/relationships and Gold aggregate checks remain unchanged.

Operational requirement: execute one pipeline at a time. No other writer may
change Bronze or Silver between validation and merge. The shared SQL re-reads the
Silver watermark rather than persisting a frozen run checkpoint. Concurrent writes
would require persisted boundaries or an isolated validated dataset.

This retains the requested strict source timestamp watermark: older/equal-time
late arrivals are excluded. It does not repair records already in Silver or undo
previously missed Bronze ingestion. Keep raw history and resolve invalid records
through a controlled source correction/quarantine process. Filtering avoids
validating complete Silver data for these row checks, but physical Bronze pruning
still depends on layout. Existing staging tables, if deployed earlier, are no
longer used; this change does not drop them remotely.
