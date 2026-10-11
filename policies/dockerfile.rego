# Package must be `main`: conftest only evaluates the `main` namespace unless
# --namespace is passed, and a policy in any other package passes vacuously
# ("0 tests"). policies/dockerfile_test.rego proves each rule fires.
package main

import rego.v1

# Input is the conftest dockerfile parser output: a flat list of instructions,
# each {Cmd, Value, Flags, Stage, ...}. LABEL Value is [k1, v1, k2, v2, ...].

final_stage := max({cmd.Stage | some cmd in input})

stage_names := {lower(cmd.Value[2]) |
	some cmd in input
	cmd.Cmd == "from"
	count(cmd.Value) == 3
	lower(cmd.Value[1]) == "as"
}

# ── Required OCI labels ────────────────────────────────────────────────────────

required_labels := {
	"org.opencontainers.image.source",
	"org.opencontainers.image.licenses",
}

label_keys contains key if {
	some cmd in input
	cmd.Cmd == "label"
	cmd.Stage == final_stage
	some i, key in cmd.Value
	i % 2 == 0
}

deny contains msg if {
	some required in required_labels
	not label_keys[required]
	msg := sprintf("Missing required OCI label: %s", [required])
}

# ── Non-root USER ──────────────────────────────────────────────────────────────
# Only the effective user of the final stage matters: switching to root to
# install packages and back to nonroot is the intended pattern.

final_users := [cmd.Value[0] |
	some cmd in input
	cmd.Cmd == "user"
	cmd.Stage == final_stage
]

deny contains "Dockerfile must set a non-root USER in its final stage" if {
	count(final_users) == 0
}

deny contains msg if {
	user := final_users[count(final_users) - 1]
	name := lower(split(user, ":")[0])
	name in {"root", "0"}
	msg := sprintf("Final stage must not run as root (USER %s)", [user])
}

# ── Forbidden instructions ─────────────────────────────────────────────────────

deny contains "Use COPY instead of ADD — ADD can unpack archives and fetch remote URLs unexpectedly" if {
	some cmd in input
	cmd.Cmd == "add"
}

# ── Digest pinning ─────────────────────────────────────────────────────────────
# Every external base must be pinned, tagged or not. `FROM scratch` and
# references to an earlier build stage are exempt.

deny contains msg if {
	some cmd in input
	cmd.Cmd == "from"
	img := cmd.Value[0]
	not contains(img, "@sha256:")
	img != "scratch"
	not stage_names[lower(img)]
	msg := sprintf("FROM %s must be pinned to a digest (@sha256:...)", [img])
}
