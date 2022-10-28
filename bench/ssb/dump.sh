#!/usr/bin/env bash
pg_dump -O -s -t "lineorder_flat1" > name.sql
