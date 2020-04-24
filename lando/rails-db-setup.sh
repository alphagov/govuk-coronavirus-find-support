#!/bin/sh
DATABASE_URL="postgres://postgres:@db:5432" TEST_DATABASE_URL="postgres://postgres:@db:5432" rails db:setup
