#!/usr/bin/env gawk -f

/./ { line = line" "$0 }
/^$/ { print line ; line = "" }
END { print line }
