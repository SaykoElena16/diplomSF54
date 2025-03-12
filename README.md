# DiplomSF54 - Ansible Playbooks for Diploma

## 📌 Описание проекта
Этот репозиторий содержит **Ansible Playbooks** для автоматической установки и настройки инфраструктуры в рамках дипломного проекта.  

### **Список серверов и установленных сервисов**
#### **1️⃣ Мониторинг-сервер (`monitoring`)**
- **Zabbix Server**
- **Grafana**
- **Filebeat**
- **OpenVPN (сервер)**

#### **2️⃣ Веб-сервер (`web`)**
- **Nginx**
- **Apache**
- **PHP**
- **Zabbix Agent**
- **Filebeat**
- **Bind (DNS)**
- **Mail-сервер**

#### **3️⃣ Сервер баз данных (`database`)**
- **PostgreSQL-12**
- **Zabbix Agent**
- **ELK (Elasticsearch, Logstash, Kibana)**

---

## 📌 Установка и развертывание

### **1️⃣ Клонирование репозитория**
```bash
git clone https://github.com/YOUR_USERNAME/ansible-diploma.git
cd ansible-diploma
```
(замени `YOUR_USERNAME` на свой GitHub-аккаунт)

### **2️⃣ Настройка Ansible**
Редактируем `ansible.cfg`, если требуется:
```ini
[defaults]
inventory = ./hosts
remote_user = ansible
ask_pass = false
```
Убедись, что `inventory.ini` содержит корректные IP-адреса всех серверов.

### **3️⃣ Запуск плейбуков**
#### 🔹 **Развертывание всех сервисов**
```bash
ansible-playbook -i inventory.ini site.yml
```
#### 🔹 **Запуск в `--check` (без реальной установки)**
```bash
ansible-playbook -i inventory.ini site.yml --check
```
#### 🔹 **Запуск только для конкретного сервера**
```bash
ansible-playbook -i inventory.ini site.yml --limit web
```
(Замените `web` на `monitoring` или `database`, если нужно)

#### 🔹 **Запуск конкретной роли (например, Grafana)**
```bash
ansible-playbook -i inventory.ini site.yml --tags grafana
```

---

## 📌 Структура проекта
```bash
/etc/ansible
│── ansible.cfg             # Конфигурация Ansible
│── hosts                   # Инвентарь серверов
│── site.yml                # Главный playbook
│── README.md               # Документация
│── roles/                  # Каталог ролей
│   ├── zabbix_server/      # Роль Zabbix Server
│   ├── grafana/            # Роль Grafana
│   ├── filebeat/           # Роль Filebeat
│   ├── openvpn/            # Роль OpenVPN
│   ├── nginx/              # Роль Nginx
│   ├── apache/             # Роль Apache
│   ├── php/                # Роль PHP
│   ├── zabbix_agent/       # Роль Zabbix Agent
│   ├── bind/               # Роль Bind DNS
│   ├── mail/               # Роль Mail
│   ├── postgresql/         # Роль PostgreSQL
│   ├── elk/                # Роль ELK Stack
│── group_vars/             # Переменные для групп хостов
│── host_vars/              # Переменные для отдельных хостов
│── playbooks/              # Дополнительные playbooks
└── .gitignore              # Игнорируемые файлы
```

---

## 📌 Описание плейбуков

| **Плейбук**    | **Описание** |
|---------------|-------------|
| `site.yml` | Главный Ansible Playbook, который запускает все роли |
| `roles/grafana/tasks/main.yml` | Устанавливает и настраивает Grafana |
| `roles/elk/tasks/main.yml` | Устанавливает и настраивает Elasticsearch, Logstash и Kibana |
| `roles/openvpn/tasks/main.yml` | Устанавливает и настраивает OpenVPN-сервер и клиентов |

---

## 📌 Работа с OpenVPN
**Настройка сервера:**
```bash
ansible-playbook -i inventory.ini roles/openvpn/tasks/main.yml
```
**Проверка статуса OpenVPN:**
```bash
systemctl status openvpn
```
**Добавление клиента в VPN:**
```bash
ansible-playbook -i inventory.ini roles/openvpn/tasks/add_client.yml
```

---

## 📌 Как добавить нового пользователя Ansible?
На всех серверах можно добавить нового пользователя (например, `mentor2`) через Ansible:
```bash
ansible all -m user -a "name=mentor2 password=$(openssl passwd -1 sf54) shell=/bin/bash" --become
```
(Пароль `sf54` )

---

## 📌 Заключение
✅ **Этот репозиторий автоматизирует установку всех ключевых сервисов**  
✅ **Использует Ansible-ролии для удобства и гибкости**  
✅ **Позволяет управлять инфраструктурой через GitHub**  

