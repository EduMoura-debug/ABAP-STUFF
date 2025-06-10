# Workflow Overview

SAP Business Workflow é uma ferramenta utilizada para integrar as funcionalidades e complementar o entendimento dos processos do sistema ECC. 

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


## Pulos do Gato

SCC1 para transporte customizing de ativação de eventos

Tarefas de etapas de diálogo precisam passar 'Tarefa Geral' para Request Customizing
Programa: RHMOVE30

SAP ALL para usuário que executa em background (WF-BATCH e/ou SAP_WFRT) 

Autorização para SWO_ASYNC 
--> Permite seguir caminho do anexo para visão de um pedido de compra por exemplo.

Transação rmps_set_substitute
--> Dar um substituto a um usuário. Todos os conteúdos da SBWP serão passados.
 
Loop Infinito + SM50 para debugar o método que acontece em background  


## Transações

SWU3 – Customizing Workflow / Configurações RFC

SWDD, PFTC, PFAC – Builder de Workflow/Task 

SWEC, SWE2 – Eventos e Vinculação de Evento

SWDM – Explorer Workflow 

SWPR – Restart de Workflow após erro

SWPC – Restart Workflow após crash no sistema

SWELS, SWEL – Rastreio de Eventos

SWUE – Disparo de Eventos

SWUS - Teste de Workflow

SWUS_WITH_REFERENCE - Iniciar Workflow com Referencia

SWI5 – Inbox do Usuário

SWU_OBUF – Sincronização do Buffer 

SWF_GMP – Visão geral do administrador do WF

SWU7 – Workflow Check para consistência

SWO1 – Builder Business Object (BOR)

SWLO – Exibir workitems do objeto Workflow 

SWWL - Eliminar Workflow 

SWU2 - RFCs presas

SMQA, SM58 - Erros de RFC

SWI2_FREQ, SWI2_DIAG - Análise do Workitem 

SWL1 - Customizing da SBWP

SWIA – Processamento Workflow como Admin 


## Funções WAPI
```
CALL FUNCTION 'SAP_WAPI_CREATE_EVENT'

CALL FUNCTION 'SAP_WAPI_START_WORKFLOW'

CALL FUNCTION 'SAP_WAPI_CREATE_WORKLIST'

CALL FUNCTION 'SAP_WAPI_GET_ATTACHMENTS'

CALL FUNCTION 'SAP_WAPI_GET_OBJECTS'

CALL FUNCTION 'SAP_WAPI_WORKITEMS_TO_OBJECT'

CALL FUNCTION 'SAP_WAPI_WORKITEM_COMPLETE'

CALL FUNCTION 'SAP_WAPI_DECISION_COMPLETE'

CALL FUNCTION 'SAP_WAPI_READ_CONTAINER'
          
CALL FUNCTION 'SAP_WAPI_WORKITEMS_BY_TASK'

CALL FUNCTION 'SAP_WAPI_GET_WORKITEM_DETAIL'

CALL FUNCTION 'SAP_WAPI_ATTACHMENT_ADD' 

CALL FUNCTION 'SAP_WAPI_ATTACHMENT_DELETE'
```

Exibir Log do WF
```
CALL FUNCTION 'SWL_WI_DISPATCH'
```

Exibir Anexos
```
CALL FUNCTION 'SWL_WI_UPDATE' 
CALL FUNCTION 'SWL_WI_REPLACE'
Principal:
CALL FUNCTION 'SWL_WI_NOTES_DISPLAY'
```

Outras Funções
```
SWW_WI_CONTAINER_DELETE
SWW_WI_OBJECTHANDLE_DELETE
SWW_WI_CONTAINER_INSERT
SWW_WI_CONTAINER_MODIFY
SWW_WI_CONTAINER_MODIFY_CHECK
SWW_WI_CONTAINER_READ
SWW_WI_CONTAINER_READ_OBJECTS
SWW_WI_READ_CONTAINERS_OF_OBJ
SWW_WI_READ_CONTAINERS_OF_OBJS
```

## BADIs Fiori

Apontamento Fiori para BADI - Transação Fiori /n/iwfnd/maint_service

/IWPGW/BADI_TGW_TASK_DATA

/IWWRK/ES_WF_WI_BEFORE_UPD_IB