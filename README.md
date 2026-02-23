# 🚀 SRE - Monitoramento Local com Docker

Projeto de monitoramento completo usando **VictoriaMetrics**, **Grafana**, **Alertmanager** e **Docker**, desenvolvido como parte da formação SRE da Alura.

---

## 📋 Sobre o Projeto

Sistema de monitoramento local que demonstra práticas de **Site Reliability Engineering (SRE)**, incluindo:

- ✅ Coleta de métricas com VictoriaMetrics
- ✅ Visualização de dados com Grafana
- ✅ Alertas automatizados com VMAlert e Alertmanager
- ✅ Healthchecks em todos os serviços
- ✅ Scripts de operação (up, down, status, logs)
- ✅ Persistência de dados

---

## 🏗️ Arquitetura
┌─────────────┐
│ App │ (Python Flask - porta 8080)
│ /metrics │ ← expõe métricas Prometheus
└──────┬──────┘
│
↓ scrape (15s)
┌─────────────────────┐
│ VictoriaMetrics │ (porta 8428)
│ Armazenamento │
└──────┬──────────────┘
│
├──→ VMAlert (porta 8880) → Alertmanager (porta 9093)
│ Avalia regras Gerencia alertas
│
└──→ Grafana (porta 3000)
Visualização

  
---  
  
## 🛠️ Tecnologias Utilizadas  
  
| Componente | Tecnologia | Porta | Função |  
|------------|------------|-------|--------|  
| **App** | Python 3.11 + Flask | 8080 | Aplicação monitorada |  
| **VictoriaMetrics** | victoriametrics/victoria-metrics:v1.93.0 | 8428 | Armazenamento de métricas |  
| **VMAlert** | victoriametrics/vmalert:v1.93.0 | 8880 | Processamento de alertas |  
| **Grafana** | grafana/grafana:11.1.0 | 3000 | Dashboards e visualização |  
| **Alertmanager** | prom/alertmanager:v0.27.0 | 9093 | Gerenciamento de alertas |  
  
---  
  
## 📁 Estrutura do Projeto  
  

sre-monitoramento-local/
├── app/
│ ├── app.py # Aplicação Flask com métricas
│ ├── Dockerfile # Imagem Docker da app
│ └── requirements.txt # Dependências Python
├── prometheus/
│ ├── prometheus.yml # Configuração de scraping
│ ├── alert_rules.yml # Regras de alerta
│ └── alertmanager.yml # Configuração do Alertmanager
├── grafana/
│ └── provisioning/
│ ├── datasources/
│ │ └── datasource.yml # VictoriaMetrics como data source
│ └── dashboards/
│ └── dashboard.yml # Provisionamento de dashboards
├── scripts/
│ ├── up.ps1 # Subir todos os containers
│ ├── down.ps1 # Parar todos os containers
│ ├── status.ps1 # Verificar status dos serviços
│ └── logs.ps1 # Ver logs dos containers
├── docker-compose.yml # Orquestração dos serviços
├── .gitignore
└── README.md

  
---  
  
## 🚀 Como Usar  
  
### Pré-requisitos  
  
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado  
- [Git](https://git-scm.com/) instalado  
- Windows com PowerShell (ou adaptar scripts para Linux/Mac)  
  
---  
  
### 1️⃣ Clonar o repositório  
  
```powershell  
git clone https://github.com/WeslleyNS/sre-monitoramento-local.git  
cd sre-monitoramento-local  

2️⃣ Subir os containers

powershell
Copy
.\scripts\up.ps1  

Aguarde uns 30-40 segundos para todos os serviços iniciarem.
3️⃣ Verificar status

powershell
Copy
.\scripts\status.ps1  

Você deve ver 5 serviços [OK]:

    ✅ App
    ✅ VictoriaMetrics
    ✅ VMAlert
    ✅ Grafana
    ✅ Alertmanager

4️⃣ Acessar os serviços
Serviço	URL	Credenciais
App	http://localhost:8080	-
App Metrics	http://localhost:8080/metrics	-
VictoriaMetrics	http://localhost:8428	-
VMAlert	http://localhost:8880/api/v1/alerts	-
Grafana	http://localhost:3000	admin / admin
Alertmanager	http://localhost:9093	-
📊 Dashboards no Grafana

Após acessar o Grafana (http://localhost:3000):

    Login: admin / admin
    Menu lateral → Dashboards
    Criar dashboard com os painéis:

Painel 1: App Status

    Query: up{job="sre_app"}
    Tipo: Stat
    Descrição: Mostra se a app está UP (1) ou DOWN (0)

Painel 2: App Uptime

    Query: time() - process_start_time_seconds{job="sre_app"}
    Tipo: Time series
    Descrição: Tempo desde que a app iniciou

Painel 3: Requests por segundo

    Query: rate(app_requests_total[1m])
    Tipo: Time series
    Descrição: Taxa de requisições por segundo

🚨 Alertas Configurados
1. AppDown (Crítico)

    Condição: App está DOWN por mais de 30 segundos
    Severidade: critical
    Ação: Notifica via Alertmanager

2. HighRequestRate (Warning)

    Condição: Mais de 5 requisições/segundo por 1 minuto
    Severidade: warning
    Ação: Notifica via Alertmanager

🧪 Testando os Alertas
Teste 1: Simular queda da aplicação

powershell
Copy
# Parar a app  
docker stop sre_app  
  
# Aguardar 30-60 segundos  
  
# Verificar alerta no Alertmanager  
# Acesse: http://localhost:9093  
  
# Subir a app novamente  
docker start sre_app  

Teste 2: Simular tráfego alto

powershell
Copy
# Gerar 20 requisições  
for ($i=1; $i -le 20; $i++) {   
    Invoke-WebRequest -Uri http://localhost:8080/ -UseBasicParsing   
}  
  
# Verificar alerta em: http://localhost:9093  

🛠️ Scripts de Operação
Subir todos os containers

powershell
Copy
.\scripts\up.ps1  

Parar todos os containers

powershell
Copy
.\scripts\down.ps1  

Ver status dos serviços

powershell
Copy
.\scripts\status.ps1  

Ver logs de um serviço específico

powershell
Copy
.\scripts\logs.ps1  
# Exemplo: digite "app" quando solicitado  

📈 Métricas Disponíveis

A aplicação expõe as seguintes métricas em /metrics:
Métrica	Tipo	Descrição
up	Gauge	Status do serviço (1 = UP, 0 = DOWN)
app_requests_total	Counter	Total de requisições recebidas
process_start_time_seconds	Gauge	Timestamp de quando o processo iniciou
process_cpu_seconds_total	Counter	Tempo de CPU usado
process_resident_memory_bytes	Gauge	Memória RAM usada
🔧 Configurações Importantes
Retenção de Dados

    VictoriaMetrics: 30 dias (configurável em docker-compose.yml)

Intervalo de Scraping

    VictoriaMetrics: 15 segundos (configurável em prometheus/prometheus.yml)

Intervalo de Avaliação de Alertas

    VMAlert: 15 segundos (configurável em docker-compose.yml)

Persistência

    Grafana: Volume grafana_data (dashboards e configurações)
    VictoriaMetrics: Volume victoria_data (métricas)

🐛 Troubleshooting
Containers não sobem

powershell
Copy
# Ver logs de todos os containers  
docker compose logs  
  
# Ver logs de um container específico  
docker compose logs victoriametrics  

Grafana não conecta ao VictoriaMetrics

    Verifique se o VictoriaMetrics está rodando: docker ps
    Teste a URL: http://localhost:8428
    No Grafana, use a URL interna: http://victoriametrics:8428

Alertas não disparam

    Verifique se o VMAlert está rodando: .\scripts\status.ps1
    Veja os logs: docker compose logs vmalert
    Verifique as regras: http://localhost:8880/api/v1/rules

Dashboards do Grafana foram perdidos

    Isso acontece se o volume grafana_data for deletado
    Recrie os dashboards manualmente ou use provisionamento automático

📚 Conceitos SRE Aplicados

Este projeto demonstra os seguintes conceitos de SRE:

    ✅ Observabilidade: Métricas, logs e alertas
    ✅ Automação: Scripts de operação e healthchecks
    ✅ Confiabilidade: Monitoramento contínuo e alertas proativos
    ✅ Infraestrutura como Código: Docker Compose e configurações versionadas
    ✅ Incident Response: Simulação e resolução de incidentes

    
    👤 Autor

Weslley NS

    GitHub: @WeslleyNS
    Projeto: sre-monitoramento-local