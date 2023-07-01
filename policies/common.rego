package common

import data.abbey.functions

allow[msg] {
    true; functions.expire_after("24h")
    msg := "granting access for 24 hours"
}