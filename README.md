# diplomSF54 - Ansible Playbooks for Diploma

# Ansible Playbooks для установки сервисов

## 📌 Описание
Этот репозиторий содержит роли Ansible для автоматической установки и настройки следующих сервисов:

- **Мониторинг-сервер** (`monitoring`):
  - Zabbix Server
  - Grafana
  - Filebeat
  - OpenVPN

- **Веб-сервер** (`web`):
  - Nginx
  - Apache
  - PHP
  - Zabbix Agent
  - Filebeat
  - Bind
  - Mail

- **БД-сервер** (`database`):
  - PostgreSQL-12
  - Zabbix Agent
  - ELK

## 📌 Установка
1. Клонируйте репозиторий:
   \`\`\`bash
   git clone https://github.com/your-repo/ansible-project.git
   \`\`\`

2. Перейдите в каталог с ролями:
   \`\`\`bash
   cd ansible-project
   \`\`\`

3. Запустите плейбук:
   \`\`\`bash
   ansible-playbook -i inventory.ini site.yml
   \`\`\`

## 📌 Замечания
- Убедитесь, что ваш `ansible.cfg` корректно настроен.
- В `README.txt` описано, какие сервисы установлены **вручную**, а какие через Ansible.

