#!/bin/bash

# Скрипт для добавления проверки установки сервисов во все Ansible роли
echo "🔄 Добавляем проверку установки сервисов во все Ansible роли..."

# Список сервисов и их команды проверки для разных ОС
declare -A SERVICES
SERVICES["zabbix-server"]="dpkg -l | grep -q zabbix-server-mysql"
SERVICES["grafana"]="dpkg -l | grep -q grafana"
SERVICES["filebeat"]="dpkg -l | grep -q filebeat"
SERVICES["openvpn"]="dpkg -l | grep -q openvpn"
SERVICES["nginx"]="dpkg -l | grep -q nginx"
SERVICES["apache"]="dpkg -l | grep -q apache2"
SERVICES["php"]="dpkg -l | grep -q php"
SERVICES["zabbix-agent"]="dpkg -l | grep -q zabbix-agent"
SERVICES["bind"]="dpkg -l | grep -q bind9"
SERVICES["mail"]="dpkg -l | grep -q postfix"
SERVICES["postgresql"]="dpkg -l | grep -q postgresql"
SERVICES["elk"]="dpkg -l | grep -q elasticsearch"

# Сопоставление ролей и серверов
declare -A ROLE_MAPPING
ROLE_MAPPING["zabbix_server"]="monitoring"
ROLE_MAPPING["grafana"]="monitoring"
ROLE_MAPPING["filebeat"]="all"
ROLE_MAPPING["openvpn"]="monitoring"
ROLE_MAPPING["nginx"]="web"
ROLE_MAPPING["apache"]="web"
ROLE_MAPPING["php"]="web"
ROLE_MAPPING["zabbix_agent"]="web database"
ROLE_MAPPING["bind"]="web"
ROLE_MAPPING["mail"]="web"
ROLE_MAPPING["postgresql"]="database"
ROLE_MAPPING["elk"]="database"

# Обход всех `tasks/*.yml` файлов во всех ролях
for role in "${!ROLE_MAPPING[@]}"; do
    for task_file in roles/$role/tasks/*.yml; do
        if [ -f "$task_file" ]; then
            for service in "${!SERVICES[@]}"; do
                # Проверяем, принадлежит ли сервис этой роли
                if [[ $role == *"$service"* ]]; then
                    # Проверяем, есть ли уже проверка данного сервиса в файле
                    if ! grep -q "Проверка, установлен ли $service" "$task_file"; then
                        cat <<EOF >> "$task_file"

# ✅ Проверка перед установкой $service
- name: Проверка, установлен ли $service (Debian)
  shell: ${SERVICES[$service]}
  register: ${service}_check
  ignore_errors: yes
  changed_when: false

- name: Установка $service (если отсутствует)
  ansible.builtin.apt:
    name: $service
    state: present
  when: ansible_os_family == "Debian" and ${service}_check.rc != 0

- name: Проверка, установлен ли $service (RHEL)
  shell: rpm -q $service
  register: ${service}_check
  ignore_errors: yes
  changed_when: false

- name: Установка $service (если отсутствует)
  ansible.builtin.yum:
    name: $service
    state: present
  when: ansible_os_family == "RedHat" and ${service}_check.rc != 0

EOF
                        echo "✅ Проверка для $service добавлена в $task_file"
                    else
                        echo "⚠️ Проверка для $service уже есть в $task_file, пропускаем."
                    fi
                fi
            done
        fi
    done
done

echo "🎉 Скрипт завершил работу!"

