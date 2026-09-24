# Ansible Configuration

Ansible setup for configuring servers provisioned by this landing zone.

## Contents

- [Ansible config/ansible.cfg](Ansible config/ansible.cfg) — Ansible settings: connects as the `ansible` user, disables host key checking, and enables privilege escalation (`become`).
- [Ansible config/hosts](Ansible config/hosts) — static inventory. Currently defines a `testservers` group.
- [main.yml](main.yml) — test playbook (`TF-DEMO | Setup basics on this machine`). Sets the timezone to `Europe/Amsterdam`, stops and disables FirewallD, and writes a welcome message to `/etc/motd`.

## Usage

When Ansible is installed use the files in the Ansible config folder.
