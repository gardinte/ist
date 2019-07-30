#!/bin/sh

release_ctl eval --mfa "Ist.Tasks.Release.migrate/1" --argv -- "$@"
