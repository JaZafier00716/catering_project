# Catering Information System

An information system for catering companies: staff manage projects (events), build menus with revisions, share a menu with a customer through a link and collect the customer's comments. It is a university semester project from [VŠB – Technical University of Ostrava](https://www.vsb.cz/en) that combines the work of two courses (VIS and TDS I), written without frameworks or ORMs as the assignment requires.

![Desktop client](https://raw.githubusercontent.com/JaZafier00716/VIS/projekt/app/screenshots/desktop-main.png)

## Features

- Project folders and documents (files stored on disk)
- Menus with revisions, side-by-side comparison and undo in the menu editor
- Sharing a menu with a customer through a link (with QR code and expiry), plus customer comments on the web page
- PDF export of menus
- Product catalogue, customers and user administration with roles (worker, administrator, manager)
- Read-only manager overview in the browser

More screenshots: [menu editor](https://raw.githubusercontent.com/JaZafier00716/VIS/projekt/app/screenshots/desktop-menu-editor.png), [revision comparison](https://raw.githubusercontent.com/JaZafier00716/VIS/projekt/app/screenshots/desktop-compare.png), [customer web page](https://raw.githubusercontent.com/JaZafier00716/VIS/projekt/app/screenshots/web-customer-menu.png), [manager overview](https://raw.githubusercontent.com/JaZafier00716/VIS/projekt/app/screenshots/web-manager-list.png).

## Repository layout

This repository only ties the two parts together. Both folders are **git submodules** that pin a commit of the original repositories.

| Folder | Source repo | What it is |
|---|---|---|
| [`vis/`](https://github.com/JaZafier00716/VIS/tree/projekt) | `JaZafier00716/VIS`, branch `projekt` | The application: a JavaFX desktop client for staff plus a small JDK `HttpServer` web part (customer menu page and manager overview). Java 21, Maven, hand-written JDBC data mappers, Apache PDFBox. Also holds the course documentation (LaTeX artefacts, class diagrams). The branch contains only the `projekt/` folder of the VIS repo (made with `git subtree split`). |
| [`tds-i/`](https://github.com/JaZafier00716/TDS-I) | `JaZafier00716/TDS-I` | The Oracle database: re-runnable DDL with constraints, triggers and indexes, seed data, integrity checks, a query catalogue and the Data Modeler logical and relational models. |

## Architecture

Three layers, with the business layer owning the interfaces (mappers, document storage) that the data layer implements:

```
presentation.{desktop,web}  ->  business.{domain,command,pricing,port,service}  <-  data.{oracle,file}
                                  AppContext = composition root
```

Data live in Oracle (JDBC with Data Mapper) and documents in a folder on disk. The application documents 17 Fowler (PoEAA) and 8 GoF patterns, each mapped to concrete classes; see the [application README](https://github.com/JaZafier00716/VIS/blob/projekt/app/README.md) for the table and the [class diagrams](https://github.com/JaZafier00716/VIS/blob/projekt/app/docs/diagrams/class-diagram.png).

## Tech stack

| Area | Technology |
|---|---|
| Language / build | Java 21, Maven |
| Desktop UI | JavaFX 21 |
| Web part | JDK `com.sun.net.httpserver.HttpServer` |
| Persistence | JDBC (ojdbc11), hand-written Data Mappers, Oracle Database 19c+ |
| Libraries | Apache PDFBox (PDF export), ZXing core (QR codes) |
| Tests | JUnit 5 (330 tests, many run against a real Oracle database and real JavaFX windows) |
| Database | Oracle SQL / PL/SQL, SQL Developer Data Modeler, Docker (`gvenzl/oracle-free`) for local development |

## Getting started

### Clone

```bash
git clone --recurse-submodules https://github.com/JaZafier00716/catering_project.git
# already cloned without submodules:
git submodule update --init
```

### Database

Start Oracle 19c or newer (locally e.g. the Docker image `gvenzl/oracle-free`, service `FREEPDB1`) and run the scripts in `tds-i/db/` as the application schema user, in this order:

1. `01_schema.sql` creates tables, constraints, triggers and indexes (re-runnable)
2. `02_seed.sql` loads the test data
3. `03_checks.sql` (optional) integrity checks and rejection tests
4. `04_queries.sql` (optional) query catalogue

Step-by-step Docker setup: [`tds-i/README.md`](https://github.com/JaZafier00716/TDS-I#readme).

### Application

JDK 21 and Maven 3.9 are required. In `vis/app`:

```bash
cp config/db.properties.example config/db.properties   # then set db.url, db.user, db.password
mvn clean test         # compile and run all tests (needs the seeded database; JavaFX tests need a display)
mvn javafx:run         # desktop client
mvn exec:java          # web server only (customer page and /manager)
```

All configuration keys and the demo accounts are described in [`vis/app/README.md`](https://github.com/JaZafier00716/VIS/blob/projekt/app/README.md).

### Updating the submodules

`update.sh` refreshes the `projekt` branch in a local VIS clone, moves both submodule pins to their latest commits and pushes the result. It is meant for the repository owner and expects the VIS clone at `~/Documents/VSB/tretak/VIS` (override with `VIS_DIR=/other/path ./update.sh`).

## Notes

University coursework (VIS: information systems, TDS I: database design) by Jan Zamostný at VŠB – Technical University of Ostrava. The documentation inside the submodules is written in Czech; code identifiers are in English. The demo data and accounts are test values, not real data.
