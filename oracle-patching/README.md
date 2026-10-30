# Oracle Patching

Ansible project for catalog-driven Oracle Grid Infrastructure (GI) and RDBMS patch workflows. Ansible runs in WSL (Ubuntu) or Ansible Automation Platform (AAP); all task commands use Linux shell conventions.

## Setup in WSL

From this project directory in Ubuntu/WSL:

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
```

Configure SSH, sudo, inventory hostnames, patch IDs, and verified SHA-256 checksums before using a real environment. Store secrets in Ansible Vault or AAP credentials; never commit them.

## Layout

| Path | Purpose |
| --- | --- |
| `inventories/` | Non-production and production hosts, environment settings, and Oracle home catalogs |
| `catalog/patches.yml` | Patch metadata and checksum catalog |
| `playbooks/` | Pre-check, GI, RDBMS, and rollback entry points |
| `roles/` | OS checks, staging, prechecks, backup, patching, validation, reporting, and notifications |
| `files/sql/` | SQL precheck, postcheck, and smoke-test scripts |
| `filter_plugins/` | SQL key/value output parser |
| `tests/` | Unit tests for the custom filter |
| `logs/` | Reserved for local run logs; generated logs are ignored by Git |

## Pre-checks

Run the read-only workflow from WSL, selecting a catalog home and change reference:

```bash
.venv/bin/ansible-playbook playbooks/precheck_only.yml \
  -e env=nonprod -e target_home=gi_nonprod_cluster01 \
  -e change_ref=CHG123456 -e mode=precheck_only
```

The playbook stages catalog bundles for analysis, runs OS and Oracle checks, and writes per-stage reports. Patch execution is intentionally not exposed as a local VS Code task; launch patch workflows through AAP after approval.

## Known limitations

- `out_of_place` backup is refused until the clone procedure is automated.
- OPatch self-update from the bundle is not automated.
- Staging runs before the approval checkpoint because applicability needs the unpacked patch.
- Per-check values appear in the report only where a role sets `stage_checks`.
- All IDs, checksums, hosts, and thresholds are placeholders.