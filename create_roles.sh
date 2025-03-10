#!/bin/bash

# Список ролей
roles=(
    "apache"
    "bind"
    "elk"
    "filebeat"
    "grafana"
    "mail"
    "nginx"
    "openvpn"
    "php"
    "postgresql_server"
    "zabbix_agent"
    "zabbix_server"
)

# Каталог, где будут созданы роли
roles_dir="/etc/ansible/roles"

# Создание структуры ролей
for role in "${roles[@]}"; do
    echo "Создаю роль: $role..."

    # Создание директорий для роли
    mkdir -p "$roles_dir/$role/{tasks,handlers,defaults,vars,meta,templates,files}"

    # Создание tasks/main.yml
    cat <<EOF > "$roles_dir/$role/tasks/main.yml"
---
- name: Установка пакетов $role
  ansible.builtin.apt:
    name: $role
    state: present
  when: ansible_os_family == "Debian"

- name: Установка пакетов $role (RHEL-based)
  ansible.builtin.yum:
    name: $role
    state: present
  when: ansible_os_family == "RedHat"

- name: Конфигурирование $role
  template:
    src: templates/$role.conf.j2
    dest: /etc/$role/$role.conf
  notify: Перезапуск $role
EOF

    # Создание handlers/main.yml
    cat <<EOF > "$roles_dir/$role/handlers/main.yml"
---
- name: Перезапуск $role
  ansible.builtin.service:
    name: $role
    state: restarted
  when: $role_config.changed
EOF

    # Создание defaults/main.yml
    cat <<EOF > "$roles_dir/$role/defaults/main.yml"
---
config_file: /etc/$role/$role.conf
EOF

    # Создание vars/main.yml
    cat <<EOF > "$roles_dir/$role/vars/main.yml"
---
service_name: $role
EOF

    # Создание meta/main.yml
    cat <<EOF > "$roles_dir/$role/meta/main.yml"
---
galaxy_info:
  author: Lena
  description: Установка и настройка $role
  company: Port-443
  license: MIT
  min_ansible_version: "2.9"
dependencies: []
EOF

done

echo "Все роли успешно созданы!"

