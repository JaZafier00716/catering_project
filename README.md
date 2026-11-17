# Catering information system

A semester project from VŠB – Technical University of Ostrava. It is an information system for catering companies, built from two courses' work:

| Folder | Source repo | What it is |
|---|---|---|
| [`vis/`](https://github.com/JaZafier00716/VIS) | JaZafier00716/VIS | The application: a JavaFX desktop client for staff plus a small JDK `HttpServer` web part (customer menu page and read-only manager overview). Java 21, Maven, hand-written JDBC data mappers, Apache PDFBox. No frameworks or ORM. |
| [`tds-i/`](https://github.com/JaZafier00716/TDS-I) | JaZafier00716/TDS-I | The Oracle database: re-runnable DDL with constraints, triggers and indexes, seed data, integrity checks, a query catalogue, and the Data Modeler logical and relational models. |

Both folders are **git submodules**: the code lives in the original repos, and this repo pins a commit of each.

![Desktop client](https://raw.githubusercontent.com/JaZafier00716/VIS/main/projekt/app/screenshots/desktop-main.png)

## Features
- Project folders and documents (stored on disk)
- Menus with revisions and side-by-side comparison
- Sharing a menu with a customer through a link, plus customer comments
- PDF export of menus
- User administration
- Read-only manager overview in the browser

## Clone

```bash
git clone --recurse-submodules https://github.com/JaZafier00716/catering_project.git
# already cloned without submodules:
git submodule update --init
```

Update both parts to their latest commits:

```bash
git submodule update --remote
git commit -am "Update submodules"
```

## Run
1. **Database:** start Oracle 19c+ (locally, Docker `gvenzl/oracle-free`, service `FREEPDB1`), then run `tds-i/db/01_schema.sql` through `04_queries.sql` in order. See [`tds-i/README.md`](https://github.com/JaZafier00716/TDS-I#readme).
2. **Application:** set `db.url`, `db.user` and `db.password` in `vis/projekt/app/config/db.properties` (start from the `.example` file), then build and run with Maven (JDK 21). See [`vis/projekt/app/README.md`](https://github.com/JaZafier00716/VIS/blob/main/projekt/app/README.md).

## Stack
Java 21 · JavaFX · JDK HttpServer · JDBC · Apache PDFBox · JUnit 5 · Maven · Oracle SQL / PL/SQL · Oracle SQL Developer Data Modeler · Docker
