# Workflow Overview

SAP Business Workflow é uma ferramenta utilizada para integrar as funcionalidades e complementar o entendimento dos processos do sistema SAP. 

O Workflow pode ser utilizado para auxiliar no andamento de processos, devido à possibilidade de combinar atividades de diferentes aplicações dentro de um mesmo processo. As informações necessárias são encaminhadas diretamente para o usuário final facilitando a execução de suas Tarefas.

Vantagens: 
Acesso simples e de forma rápida às informações; 
Recebimento imediato de notificações de Tarefas a serem executadas; 
Facilitar o entendimento do processo;  
Melhor controle das informações: 
    - Prazo para execução das Tarefas; 
    - Responsáveis pela execução das Tarefas; 
    - Possibilidade de monitoramento de cada processo do início ao fim; o
    - Flexibilidade de mudança no processo;

## Nomes Técnicos

- Workitem: Workitems são atividades ou Tarefas disponíveis para execução. Podem ser executadas em background ou em diálogo com o usuário. 

- Tasks: Complementando o workitem, as Tarefas do WF são usadas para executar lógicas ABAP, definir um responsável pela ação, envio de e-mail, entre outras funcionalidades. Isso pode ocorrer de forma interativa ou em background.

- Objeto BOR: Business Object Repository é um tipo de objeto com campos chave, interfaces, métodos e eventos que estão ligados com a execução do WF. Os métodos do objeto são referenciadas nas Tasks. 

- Etapas (Steps): Cada passo que o workflow toma, cada etapa se referencia a uma Task.

- Business Workplace: Lugar onde o usuário executa Workflows. Transação SBWP ou My Inbox app no FIORI. 

- Container: É a estrutura de dados que armazena informações dos componentes do Workflow. Estas informações podem ser referentes a campos, tabelas, estruturas, etc. 

- Binding: Definir um binding, ou ligação, permite atribuir valores a elementos de Containers e transferir um valor de um Container para o outro.

O Workflow se inicia quando um evento “dispara”, ou seja, é gerado o workflow quando o evento ocorrer ou for chamado. Cada Tarefa possui um método que vai executar lógicas e preencher containers. Algumas etapas/atividades serão tarefas de diálogo e precisariam de um input do usuário.

Obs: Os usuários, os quais recebem tarefas para executar/aprovar, são comumente definidos a partir de tabelas Z (preenchidas em métodos anteriores), regras (FMs definidas na própria tarefa) ou cargos organizacionais em fluxos não standard.


## Arquivar Workflow

 Simplificando, quando você *arquiva* um workflow, ele é removido da instância SAP e colocado offline (ou seja, em um arquivo no seu servidor de aplicativos). 
 
 O workflow (e todos os seus itens de trabalho, anexos, histórico de logs etc.) ainda está disponível para acesso somente leitura, mas seus dados desaparecem de muitas tabelas grandes do banco de dados SAP. Isso deixa o pessoal do Basis muito feliz. 
 
 O arquivamento ocorre em duas etapas distintas: gravando um workflow em um arquivo compactado e, em seguida, excluindo o workflow do sistema SAP. Observe que você só pode arquivar workflows com o status CONCLUÍDO (ou CANCELADO). 
 
 Por que você faria isso? Você pode arquivar workflows se:

- Seu sistema de produção está em execução há alguns anos

- Suas tabelas críticas de fluxo de trabalho SAP (como SWWWIHEAD, SWNCNTP0) estão crescendo rapidamente, impactando o desempenho e tornando as tarefas básicas mais lentas
(como backups do sistema)

- Você está migrando para um novo sistema e deseja reduzir a quantidade de dados da tabela do banco de dados

Os riscos são pequenos. Esse procedimento existe há anos e é (presumivelmente) usado rotineiramente por milhares de grandes clientes SAP. Você não "exclui" os workflows até que o processo de "gravação" seja concluído com sucesso. E sim, os workflows são fisicamente excluídos do sistema de produção, mas permanecem em arquivos.

É claro que você precisa ter muito cuidado com esses arquivos; agora é responsabilidade da equipe do Basis mantê-los seguros e com backup adequado.

## Transações SAP Workflow (Organizadas e Traduzidas)

| Código (T-Code) | Tradução da Função | Categoria Principal |
| :--- | :--- | :--- |
| **SWDD** | **Builder de Workflow** (Criação e Modificação de Modelos) | Design e Build |
| **PFTC** | **Manutenção de Tarefas** (Workflow Tasks, Tipos de Tarefa e Tasks Padrão) | Design e Build |
| **PFAC** | **Manutenção de Regras** (Definição de Agentes/Executores) | Design e Build |
| **SWDA** | Builder de Workflow Alfanumérico | Design e Build |
| **SWO1** | **Builder de Business Object (BOR)** | BOR |
| **SWO2** | Browser / Display do Business Object Repository (BOR) | BOR |
| **SWU3** | **Customizing Automático do Workflow** / Configurações RFC | Configuração |
| **SWFC** | Customizing Automático do Workflow (Alternativo) | Configuração |
| **SWUG** | Gerar Transação de Início de Workflow | Configuração |
| **SWEC** | **Vinculação de Eventos para Documentos de Modificação** (*Change Documents*) | Eventos e Vinculação |
| **SWE2** / **SWETYPV** | **Exibir/Manter Vinculações de Tipo de Evento** | Eventos e Vinculação |
| **SWEL** | **Exibir Rastreio de Eventos** | Rastreio e Log |
| **SWELS** | Ligar/Desligar Rastreio de Eventos | Rastreio e Log |
| **SWEM** | Configurar Rastreio de Eventos | Rastreio e Log |
| **SWU0** | Simular Evento | Teste e Execução |
| **SWUE** | **Disparar um Evento** | Teste e Execução |
| **SWUS** | **Testar Workflow** | Teste e Execução |
| **SWU4** / **SWU5** / **SWU6** / **SWU7** | Testes de Consistência (Task Padrão, Cliente, Workflow, Template) | Teste e Execução |
| **SWDM** | **Workflow Explorer** (Explorador de Modelos) | Administração e Monitoramento |
| **SWI1** | **Relatório de Seleção para Workflows** | Administração e Monitoramento |
| **SWI5** / **SWI5N** | **Análise da Carga de Trabalho** (Inbox do Usuário) | Administração e Monitoramento |
| **SWIA** | **Relatório de Administração de Work Item** (Processar como Admin) | Administração e Monitoramento |
| **SWPR** | **Reiniciar Workflow após Erro** | Administração e Monitoramento |
| **SWPC** | Reiniciar Workflow após Crash no Sistema | Administração e Monitoramento |
| **SWWL** | **Eliminar Work Item** / Workflow | Administração e Monitoramento |
| **RSWWERRE** | Executar Monitoramento de Erros do Workflow | Administração e Monitoramento |
| **SWEQADM** | Administrar Fila de Eventos | Administração e Monitoramento |
| **SWU1** / **SWU2** | Monitor de RFC do Usuário / Monitor de RFC do Workflow | Monitoramento Técnico |
| **SWU_OBUF** | Sincronização do Buffer (do BOR) | Utilitários |
| **SWL1** | Configurações para Colunas Dinâmicas (SBWP) | Utilitários |
| **SWDD_SCENARIO** | Workflow Flexível (Criação/Exibição de Cenários - S/4HANA) | S/4HANA Flex WF |
| **SWF_PROCESS_ADMIN** | Checar se o Cenário de Workflow está ativo | S/4HANA Flex WF |