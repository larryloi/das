# Release Note


## 2.2.0-mysql8

### Scope of changes
|**Subject**|**Description**|
|:------------------------------------|:--------------------------------|
|**Minimize skipping records issue**  | Form update_trace method, remvoe the fractional seconds from traced_at, synced_at |

#### Detail
- lib/chronos2/jobs/traceable.rb remvoe the fractional seconds from traced_at, synced_at

---

## 2.1.0-mysql8

### Scope of changes
|**Subject**|**Description**|
|:------------------------------------|:--------------------------------|
|**ETL extraction tuning**  | monitor_operations change to check chronos_traces rather than chronos_trace_logs |

#### Detail
- monitor_operations/inspect_latencies.rb changed to check chronos_traces rather than chronos_trace_logs

---

## 2.0.0-mysql8

### Scope of changes
|**Subject**|**Description**|
|:------------------------------------|:--------------------------------|
|**ETL extraction tuning**  | Added chronos_traces table; for speed up sync time checking of source tables for ETL jobs |

#### Detail
- Upgrade the docker image to ruby:2.5.8 (Native)
- Upgrade chronos version to chronos2 version to 0.2.0 (ETL Source checking tuning)
- Alert email method change from shell (mailx) command to ruby (net/smtp)

---

## 1.0.1-mysql8

### Scope of changes
|**Subject**|**Description**|
|:------------------------------------|:--------------------------------|
|**db migration enhancement**  | added fractional_seconds, encoding parameters; To control datetime precision while creating table column |

#### Detail
New Environment variable must be specified While startup container
```
DST_FRACTIONAL_SECONDS=true
DST_ENCODING=utf8mb4
```
