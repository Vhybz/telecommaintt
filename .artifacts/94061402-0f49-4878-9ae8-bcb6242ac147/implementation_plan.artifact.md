# Dashboard Data Integration & Insights Plan

This plan aims to replace all hardcoded values and sections in the Dashboard with real data from the database and the machine learning model metadata, providing "real insights" as requested.

## User Review Required

> [!IMPORTANT]
> The dashboard will now depend on active database connections (Supabase) and the local `model_metadata.json` asset. Ensure the backend services are running.

## Proposed Changes

### [Dashboard Feature]

#### [MODIFY] [dashboard_screen.dart](file:///C:/Users/USER/StudioProjects/telecomf/lib/features/dashboard/presentation/dashboard_screen.dart)
- Integrate `predictionsProvider` to populate the "Fault Prediction Summary" table.
- Integrate `modelMetadataProvider` to display real model accuracy and version.
- Integrate `stationsProvider` to drive the "Equipment Health Overview" chart and stat cards.
- Integrate `alarmsProvider` to show the latest real alerts from the database.
- Add an "Insights" section or dynamic text that summarizes the most frequent predicted fault or highest risk area.
- Fix all linter warnings (unused imports, string interpolation, etc.).

## Verification Plan

### Automated Tests
- Run `flutter test` (if applicable) to ensure no regressions in existing logic.

### Manual Verification
- Inspect the Dashboard in the emulator/device to verify:
    - Stat cards match the `base_stations` table in Supabase.
    - Model accuracy reflects `model_metadata.json`.
    - Prediction table shows real data from the `predictions` table.
    - Latest alerts show real data from the `alarm_logs` table.
