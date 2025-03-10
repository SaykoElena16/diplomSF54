#!/bin/bash

# Создаём массив с названиями ролей
ROLES=("openvpn_server" "openvpn_client")

# Создаём структуру директорий для каждой роли
for role in "${ROLES[@]}"; do
    echo "Создаю роль: $role..."

    mkdir -p "/etc/ansible/roles/$role/{tasks,handlers,defaults,vars,meta,templates,files}"

    # tasks/main.yml
    cat <<EOF > "/etc/ansible/roles/$role/tasks/main.yml"
---
- name: Установка OpenVPN для $role
  ansible.builtin.apt:
    name: openvpn
    state: present
  when: ansible_os_family == "Debian"

- name: Установка OpenVPN для $role (RHEL-based)
  ansible.builtin.yum:
    name: openvpn
    state: present
  when: ansible_os_family == "RedHat"

- name: Копирование конфигурации OpenVPN
  template:
    src: $role.conf.j2
    dest: /etc/openvpn/$role.conf
  notify: Перезапуск OpenVPN
EOF

    # handlers/main.yml
    cat <<EOF > "/etc/ansible/roles/$role/handlers/main.yml"
---
- name: Перезапуск OpenVPN
  ansible.builtin.service:
    name: openvpn
    state: restarted
  when: openvpn_config.changed
EOF

    # defaults/main.yml
    cat <<EOF > "/etc/ansible/roles/$role/defaults/main.yml"
---
config_file: /etc/openvpn/$role.conf
EOF

    # vars/main.yml
    cat <<EOF > "/etc/ansible/roles/$role/vars/main.yml"
---
service_name: openvpn
EOF

    # meta/main.yml
    cat <<EOF > "/etc/ansible/roles/$role/meta/main.yml"
---
galaxy_info:
  author: Lena
  description: Установка и настройка OpenVPN ($role)
  company: Port-443
  license: MIT
  min_ansible_version: "2.9"
dependencies: []
EOF

    echo "Роль $role создана!"
done

echo "✅ Все роли OpenVPN успешно созданы!"
