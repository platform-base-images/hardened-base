# Negative controls for policies/dockerfile.rego — run with
#   conftest verify --policy policies
# Each test proves a rule fires, so a passing `conftest test` means the rules
# ran rather than matched nothing.
package main

import rego.v1

digest := "cgr.dev/chainguard/wolfi-base:latest@sha256:00fd4e9cdd9c5576c336d979fa663f9976f160c456b6ae9fe87e19c4e9c759a2"

labels := [
	{"Cmd": "label", "Stage": 0, "Value": ["org.opencontainers.image.source", "\"https://example\""]},
	{"Cmd": "label", "Stage": 0, "Value": ["org.opencontainers.image.licenses", "\"Apache-2.0\""]},
]

good := array.concat(
	[{"Cmd": "from", "Stage": 0, "Value": [digest]}],
	array.concat(labels, [
		{"Cmd": "user", "Stage": 0, "Value": ["root"]},
		{"Cmd": "run", "Stage": 0, "Value": ["apk add python"]},
		{"Cmd": "user", "Stage": 0, "Value": ["nonroot"]},
	]),
)

test_hardened_pattern_passes if {
	count(deny) == 0 with input as good
}

test_multi_key_label_instruction_parsed if {
	one_line := [
		{"Cmd": "from", "Stage": 0, "Value": [digest]},
		{"Cmd": "label", "Stage": 0, "Value": [
			"org.opencontainers.image.source", "\"https://example\"",
			"org.opencontainers.image.licenses", "\"Apache-2.0\"",
		]},
		{"Cmd": "user", "Stage": 0, "Value": ["nonroot"]},
	]
	count(deny) == 0 with input as one_line
}

test_missing_label_denied if {
	no_license := [c | some c in good; not c.Value[0] == "org.opencontainers.image.licenses"]
	deny["Missing required OCI label: org.opencontainers.image.licenses"] with input as no_license
}

test_final_user_root_denied if {
	ends_root := array.concat(good, [{"Cmd": "user", "Stage": 0, "Value": ["root"]}])
	deny["Final stage must not run as root (USER root)"] with input as ends_root
}

test_final_user_uid_zero_denied if {
	ends_zero := array.concat(good, [{"Cmd": "user", "Stage": 0, "Value": ["0:0"]}])
	deny["Final stage must not run as root (USER 0:0)"] with input as ends_zero
}

test_missing_user_denied if {
	no_user := [c | some c in good; c.Cmd != "user"]
	deny["Dockerfile must set a non-root USER in its final stage"] with input as no_user
}

test_builder_stage_root_allowed if {
	multi := array.concat(
		[
			{"Cmd": "from", "Stage": 0, "Value": [digest, "AS", "builder"]},
			{"Cmd": "user", "Stage": 0, "Value": ["root"]},
		],
		[
			{"Cmd": "from", "Stage": 1, "Value": [digest]},
			{"Cmd": "label", "Stage": 1, "Value": ["org.opencontainers.image.source", "\"x\""]},
			{"Cmd": "label", "Stage": 1, "Value": ["org.opencontainers.image.licenses", "\"x\""]},
			{"Cmd": "user", "Stage": 1, "Value": ["nonroot"]},
		],
	)
	count(deny) == 0 with input as multi
}

test_add_denied if {
	with_add := array.concat(good, [{"Cmd": "add", "Stage": 0, "Value": ["x", "/x"]}])
	some msg in deny with input as with_add
	startswith(msg, "Use COPY instead of ADD")
}

test_tagged_unpinned_from_denied if {
	tagged := array.concat([{"Cmd": "from", "Stage": 0, "Value": ["python:3.12"]}], [c | some c in good; c.Cmd != "from"])
	deny["FROM python:3.12 must be pinned to a digest (@sha256:...)"] with input as tagged
}

test_untagged_unpinned_from_denied if {
	untagged := array.concat([{"Cmd": "from", "Stage": 0, "Value": ["ubuntu"]}], [c | some c in good; c.Cmd != "from"])
	deny["FROM ubuntu must be pinned to a digest (@sha256:...)"] with input as untagged
}

test_from_previous_stage_allowed if {
	from_stage := array.concat(
		[
			{"Cmd": "from", "Stage": 0, "Value": [digest, "AS", "builder"]},
			{"Cmd": "from", "Stage": 1, "Value": ["builder"]},
		],
		[c | some c in good; c.Cmd != "from"],
	)
	not any_pin_denial with input as from_stage
}

test_from_scratch_allowed if {
	scratch := array.concat([{"Cmd": "from", "Stage": 0, "Value": ["scratch"]}], [c | some c in good; c.Cmd != "from"])
	not any_pin_denial with input as scratch
}

any_pin_denial if {
	some msg in deny
	contains(msg, "must be pinned")
}
