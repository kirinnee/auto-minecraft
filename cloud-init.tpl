#cloud-config

users:
- name: mc
  sudo: ALL=(ALL) NOPASSWD:ALL
  groups: users, admin
  lock_passwd: true
  ssh_authorized_keys:
    - ${ssh_key}
